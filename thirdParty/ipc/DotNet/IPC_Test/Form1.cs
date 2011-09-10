using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace WindowsApplication4
{
	public class Form1 : System.Windows.Forms.Form
	{
		private IPC ipc;

		private System.Windows.Forms.ListBox MyLB;
		private System.Windows.Forms.TextBox textBox1;
		private System.Windows.Forms.Button btnSend;
		private System.Windows.Forms.Button btnStress;
		private System.Windows.Forms.TextBox textBox2;
        private Button btnSendBinary;

		private System.ComponentModel.Container components = null;

		public Form1(){
			InitializeComponent();			
			ipc = new IPC(this);
			ipc.Handler += ipc_Handler;
            MyLB.Items.Add("This application HWND: " + this.Handle);
		}

        private void ipc_Handler(object sender, IPCEventArgs ea) 
		{
            string s;

            if (ea.Data != null)
            {
                Point pt = BytesToPoint(ea.Data);
                s = String.Format("{0}     Hwnd: {1}      Binary Data: POINT( {2}, {3} )      DataSize: {4}", ea.Port, ea.Hwnd, pt.X, pt.Y, ea.Data.Length);
            }
            else s = String.Format("{0}     Hwnd: {1}      Message: {2}", ea.Port, ea.Hwnd, ea.Text);
			
            MyLB.Items.Add( s );
		}

		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.MyLB = new System.Windows.Forms.ListBox();
            this.btnSend = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.btnStress = new System.Windows.Forms.Button();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.btnSendBinary = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // MyLB
            // 
            this.MyLB.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.MyLB.ItemHeight = 16;
            this.MyLB.Location = new System.Drawing.Point(0, 46);
            this.MyLB.Name = "MyLB";
            this.MyLB.Size = new System.Drawing.Size(472, 292);
            this.MyLB.TabIndex = 0;
            // 
            // btnSend
            // 
            this.btnSend.Location = new System.Drawing.Point(250, 9);
            this.btnSend.Name = "btnSend";
            this.btnSend.Size = new System.Drawing.Size(51, 28);
            this.btnSend.TabIndex = 1;
            this.btnSend.Text = "Send";
            this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
            // 
            // textBox1
            // 
            this.textBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox1.Location = new System.Drawing.Point(3, 9);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(200, 26);
            this.textBox1.TabIndex = 2;
            this.textBox1.Text = "C# message to AHK";
            // 
            // btnStress
            // 
            this.btnStress.Location = new System.Drawing.Point(406, 9);
            this.btnStress.Name = "btnStress";
            this.btnStress.Size = new System.Drawing.Size(57, 28);
            this.btnStress.TabIndex = 3;
            this.btnStress.Text = "Stress";
            this.btnStress.Click += new System.EventHandler(this.btnMassive_Click);
            // 
            // textBox2
            // 
            this.textBox2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox2.Location = new System.Drawing.Point(206, 9);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(38, 26);
            this.textBox2.TabIndex = 4;
            this.textBox2.Text = "100";
            // 
            // btnSendBinary
            // 
            this.btnSendBinary.DialogResult = System.Windows.Forms.DialogResult.No;
            this.btnSendBinary.Location = new System.Drawing.Point(304, 9);
            this.btnSendBinary.Name = "btnSendBinary";
            this.btnSendBinary.Size = new System.Drawing.Size(97, 28);
            this.btnSendBinary.TabIndex = 5;
            this.btnSendBinary.Text = "Send Binary";
            this.btnSendBinary.Click += new System.EventHandler(this.btnSendBinary_Click);
            // 
            // Form1
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(6, 15);
            this.ClientSize = new System.Drawing.Size(467, 343);
            this.Controls.Add(this.btnSendBinary);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.btnStress);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.btnSend);
            this.Controls.Add(this.MyLB);
            this.Location = new System.Drawing.Point(300, 315);
            this.Name = "Form1";
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

		}
		#endregion

		[STAThread]
		static void Main() 
		{
			Application.Run( new Form1() );
		}

		private void btnSend_Click(object sender, System.EventArgs e)
		{
            IntPtr hReceiver = GetReceiver();

            if (!ipc.Send(hReceiver, textBox1.Text, Convert.ToInt32(textBox2.Text)))
				MessageBox.Show("Sending failed");
		}

		private void btnMassive_Click(object sender, System.EventArgs e)
		{
            IntPtr hReceiver = GetReceiver();

			for (int i=1; i<=1000; i++)
                ipc.Send(hReceiver, textBox1.Text + " : " + i.ToString(), Convert.ToInt32(textBox2.Text));
        }

        unsafe private void btnSendBinary_Click(object sender, EventArgs e)
        {
            IntPtr hReceiver = GetReceiver();            
            byte[] data = PointToBytes( new Point(2000, 8000) );
            
            if (!ipc.Send(hReceiver, data, Convert.ToInt32(textBox2.Text)))
                MessageBox.Show("Sending failed");
        }

        private IntPtr GetReceiver()
        {
            IntPtr hReceiver = IPC.WinExist("Csharp.ahk");
            if (hReceiver == IntPtr.Zero)
                MessageBox.Show("Csharp.ahk doesn't exist");

            return hReceiver;
        }

        static unsafe byte[] PointToBytes(Point p)
        {
            byte[] arr = new byte[sizeof(Point)];
            fixed (byte* parr = arr)
                *((Point*)parr) = p; 

            return arr;
        }

        static unsafe Point BytesToPoint(byte[] arr)
        {
            if (arr.Length < sizeof(Point))
                throw new ArgumentException();

            Point p;
            fixed (byte* parr = arr)
                p = *((Point*)parr); 
            return p;
        }
	}
}
