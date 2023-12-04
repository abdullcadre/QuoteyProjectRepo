B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.8
@EndOfDesignText@
Sub Class_Globals
	Dim XUI As XUI
	Dim a As Activity
End Sub

Public Sub Initialize
	 
End Sub
 
 

Sub GetHeightText(text As String,Textsize As Int) As Int
	Dim altura As Int
	Dim p As Panel
	p.Initialize("")
	Dim Label1 As Label
	Label1.Initialize("")
	Label1.Text = text
	Label1.TextSize = Textsize
	Label1.Visible=False
	p.AddView(Label1, 10dip, 10dip, 100%x, 45dip)
	Dim su As StringUtils
	altura = su.MeasureMultilineTextHeight(Label1, text)+45dip
	Return altura
End Sub

Private Sub Panel3ISelect_Click
End Sub
 
'xui is a global XUI variable.
Sub CreateRoundBitmap (Input As B4XBitmap, Size As Int) As B4XBitmap
	If Input.Width <> Input.Height Then
		Dim l As Int = Min(Input.Width, Input.Height)
		Input = Input.Crop(Input.Width / 2 - l / 2, Input.Height / 2 - l / 2, l, l)
	End If
	Dim c As B4XCanvas
	Dim xview As B4XView = XUI.CreatePanel("")
	xview.SetLayoutAnimated(0, 0, 0, Size, Size)
	c.Initialize(xview)
	Dim path As B4XPath
	path.InitializeOval(c.TargetRect)
	c.ClipPath(path)
	c.DrawBitmap(Input.Resize(Size, Size, False), c.TargetRect)
	c.RemoveClip
	c.DrawCircle(c.TargetRect.CenterX, c.TargetRect.CenterY, c.TargetRect.Width / 2 - 2dip, XUI.Color_White, False, 2dip) 'comment this line to remove the border
	c.Invalidate
	Dim res As B4XBitmap = c.CreateBitmap
	c.Release
	Return res
End Sub

Sub MakeTransparent(Color As Int, Alpha As Int) As Int
	Return Bit.And(Color, Bit.Or(0x00FFFFFF, Bit.ShiftLeft(Alpha, 24)))
End Sub

Sub Spaceing(label1 As Label,space As Float)
	Dim Obj1 As Reflector
	Obj1.Target = label1
	Obj1.RunMethod3("setLineSpacing", 1, "java.lang.float", space, "java.lang.float")
End Sub