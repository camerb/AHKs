/* About: 
    o IPC library for dotNet ver 2.6 by majkinetor <miodrag.milic@gmail.com> 
	o Fixes for 64b systems made by Lexikos.
    o See IPC module for AutoHotKey at http://www.autohotkey.com/forum/viewtopic.php?t=21699 
	o MSDN Reference: http://www.google.com/search?client=opera&rls=en-GB&q=wm_copydata&sourceid=opera&ie=utf-8&oe=utf-8 
	o Licenced under GNU GPL <http://creativecommons.org/licenses/GPL/2.0/> 
    o Note: Must be compiled with "/unsafe" option. 
 */ 
using System; 
using System.Runtime.InteropServices; 
using System.Windows.Forms; 


/// <summary> 
/// Event Arguments for IPC class 
/// </summary> 
public class IPCEventArgs : EventArgs 
{ 
    /// <summary> 
    /// Handle of the receiver. 
    /// </summary> 
    public IntPtr Hwnd; 
    /// <summary> 
    /// Binary data. 
    /// </summary> 
    public Byte[] Data; 
    /// <summary> 
    /// If data is textual message, it will be saved in this property. 
    /// </summary> 
    public string Text; 
    /// <summary> 
    ///  Port, by default 100.  Positive integer. 
    /// </summary> 
    public int Port; 

} 
/// <summary> 
/// Inter-Process Communication using WM_COPYDATA. 
/// </summary> 
public class IPC : NativeWindow 
{ 
   /// <summary> Delegate for MessageHandler. </summary> 
    public delegate void MessageHandler(object sender, IPCEventArgs ea); 

   /// <summary>Event fired when message arrives</summary> 
    public event MessageHandler Handler; 

   #region Private fields 
   const int    WM_COPYDATA = 74; 
                        
   [StructLayout(LayoutKind.Sequential)] 
   struct COPYDATASTRUCT 
   { 
      public IntPtr dwData; 
      public int cbData; 
      public IntPtr lpData; 
   } 
       
   COPYDATASTRUCT CD; 
   #endregion 

   #region Win32 imports 
   [DllImport("user32.dll", SetLastError = true)] 
   private static extern IntPtr FindWindow(string lpClassName, string lpWindowName); 
    
   [DllImport("user32.dll",CharSet=CharSet.Ansi)] 
   private static extern int SendMessage(IntPtr hWnd, int wMsg, IntPtr wParam, ref COPYDATASTRUCT lParam);    
   #endregion 
    
   ///<summary> Creates IPC object. </summary> 
   ///<param name="Host">Form object that will monitor and accept communication with other process</param> 
   public IPC(Form Host) 
   { 
      this.AssignHandle(Host.Handle); 
   } 

   ///<summary> Find window by title </summary> 
   ///<param name="WinTitle">Window title, case insensitive</param> 
   public static IntPtr WinExist( string WinTitle ) 
   { 
      return FindWindow(null, WinTitle); 
   } 
    
   ///<summary>Send the textual message to another process (receiver).</summary> 
    ///<param name="Hwnd">Handle of the receiver</param> 
    ///<param name="Text">Message to be sent</param> 
    ///<param name="Port">Port on which to send the message, positive integer</param> 
    public bool Send(IntPtr Hwnd, string Text, int Port) 
   { 
      COPYDATASTRUCT cd = new COPYDATASTRUCT(); 
        cd.dwData = (IntPtr)(-Port);                                          //use negative port for textual messages 
        cd.cbData = Text.Length + 1; 
        cd.lpData = Marshal.StringToHGlobalAnsi(Text); 
       
      //IntPtr pcd = Marshal.AllocCoTaskMem(Marshal.SizeOf(cd));   // Alocate memory 
      //Marshal.StructureToPtr(cd, pcd, true);               // Converting structure to IntPtr 
        int i = SendMessage(Hwnd, WM_COPYDATA, this.Handle, ref cd);    
      return i==1 ? true : false; 
   } 

    ///<summary>Send the binary data to another process (receiver).</summary> 
    ///<param name="Hwnd">Handle of the receiver</param> 
    ///<param name="Data">Data to be sent</param> 
    ///<param name="Port">Port on which to send the message, positive integer.</param> 
    unsafe public bool Send(IntPtr Hwnd, byte[] Data, int Port) 
    { 
        COPYDATASTRUCT cd = new COPYDATASTRUCT(); 
        cd.dwData = new IntPtr(Port); 
        cd.cbData = Data.Length; 

        int res; 
        fixed ( Byte* p = &Data[0] ) 
        { 
           cd.lpData = new IntPtr(p); 
           res = SendMessage(Hwnd, WM_COPYDATA, this.Handle, ref cd); 
        }      
        return res == 1 ? true : false; 
    } 

   protected override void WndProc(ref Message m) 
   { 
        if (Handler == null) return; 

      if (m.Msg==WM_COPYDATA)   { 
         CD = (COPYDATASTRUCT)m.GetLParam(typeof(COPYDATASTRUCT)); 

            IPCEventArgs ea = new IPCEventArgs(); 
            ea.Hwnd = m.WParam; 
            ea.Port = (int)CD.dwData.ToInt64(); //CD.dwData.ToInt32(); 

            if (ea.Port < 0) { 
                ea.Port = -ea.Port; 
                ea.Text = Marshal.PtrToStringAnsi(CD.lpData, CD.cbData); 
           } else { 
                ea.Data = new byte[CD.cbData]; 
                Marshal.Copy(CD.lpData, ea.Data, 0, CD.cbData); 
            }                                       
            Handler( this, ea ); 
         return; 
      } 
       
      base.WndProc(ref m); 
   } 
}