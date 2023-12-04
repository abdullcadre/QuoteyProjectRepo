B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.8
@EndOfDesignText@
#Region Shared Files
'#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip
 

 

Sub Class_Globals
	 
	Public Root As B4XView
	Private effects As BitmapCreatorEffects
	Private xui As XUI 'ignore
	Dim util As Utilities
	 Private Label1Back As B4XView
	 Private Label2Menu_Options As B4XView
	Private Panel1AreaShot As B4XView
	Private Panel1Menu As B4XView
	Public ImageView1User As B4XView
	Private Mesage As B4XView
	Private Label1UserName As B4XView
	Private Panel1Post As B4XView
	Dim StartX      As Int									' used only for panel dragging
	Dim StartY      As Int
	Private OriginalBmp As B4XBitmap
'	'Bottom Navigation
	Private AS_TabMenuAdvanced1 As AS_TabMenuAdvanced
	'overlay
	Public Overlay As B4XView
	Private xui As XUI
	Private pnlBottom As B4XView
	Private OverlayVisible As Boolean
	Private Panel3ISelect As B4XView
	'Cofigs
	Dim Blureffect As Boolean=False
	Dim MyName As String="Abdul Cadre"
	Dim UserName As String="@abdullcadre"
	Dim MyMSG As String="B4A – The simple way to develop native Android apps B4A includes all the features needed To quickly develop any Type of Android app."
	Dim TsizeValue As Int=16
	Dim RadiusValue As Int=1
	Dim TraspareceValue As Int=255
	Dim colorBackGroud As Int=0
	Dim Brightness As Float=100
	Dim budgetValue As Boolean=True
	Private BarTsize As B4XSeekBar
	Private B4XSwitch1budget As B4XSwitch
	Private BorderRadius As B4XSeekBar
	Private B4XSeekBar1trasparece As B4XSeekBar
	Private Label1Radius As B4XView
	Private Label1separtor As B4XView
	Private Label2Tsize As B4XView
	Private Label3Close As B4XView
	Private Label3Transparent As B4XView
	Private Label4LEdit As B4XView
	Private Label1 As B4XView
	Private DetailsDialog As CustomLayoutDialog
	Private EditText2username As EditText
	Private EditText1name As EditText
	Private SeekBrightLevel As B4XSeekBar
	Private Label1Brightness As Label
	Private B4XSwitch1Blureffect As B4XSwitch
	Private EditText1Msg As EditText
End Sub


''You can add more parameters here.
'Public Sub Initialize As Object
'	Return Me
'End Sub
Public Sub Initialize
	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Sleep(999)
	util.Initialize
	Root = Root1
	Root.LoadLayout("CreatePost")
	effects.Initialize
	colorBackGroud=util.MakeTransparent(0xfFF17212D,TraspareceValue)
	Panel1Post.Color=colorBackGroud
	If File.Exists( xui.DefaultFolder, "Background.jpg")  Then
	Else
		Wait For (File.CopyAsync(File.DirAssets, "img2.jpg", xui.DefaultFolder, "Background.jpg")) Complete (Success As Boolean)
		Log("Success: " & Success)
	End If
	If File.Exists( xui.DefaultFolder, "profile.jpg")  Then
	Else
		Wait For (File.CopyAsync(File.DirAssets, "twitter-avi-gender-balanced-.jpg", xui.DefaultFolder, "profile.jpg")) Complete (Success As Boolean)
		Log("Success: " & Success)
	End If
	OriginalBmp = xui.LoadBitmapResize(xui.DefaultFolder, "Background.jpg",Panel1AreaShot.Height,Panel1AreaShot.Height,True)
	callBottomNavigation
	ListenTouchEvent(Panel1Post)
	formatUI
End Sub

Sub B4XPage_Appear
'	Root.LoadLayout("CreatePost")
	checkbudgetValue
	changeProfilePic
	changeBackGroudPic
End Sub


#Region BottomNavigation 
Private Sub callBottomNavigation
	#If B4I	
	xpnl_bottom = xui.CreatePanel("")
	Root.AddView(xpnl_bottom,0,0,Root.Width,B4XPages.GetNativeParent(Me).SafeAreaInsets.Bottom)
	xpnl_bottom.Color = 0xFF202125
	#End If	
	 
	AS_TabMenuAdvanced1.AddTab("Budget",xui.LoadBitmap(File.DirAssets,"icons8_Approval_24px.png"),xui.LoadBitmap(File.DirAssets,"icons8_Approval_24px.png"))
	AS_TabMenuAdvanced1.AddTab("Edit Layout",xui.LoadBitmap(File.DirAssets,"icons8_Tune_64px.png"),xui.LoadBitmap(File.DirAssets,"icons8_Tune_64px.png"))
	AS_TabMenuAdvanced1.AddTab("Background",xui.LoadBitmap(File.DirAssets,"icons8_Full_Image_64px.png"),xui.LoadBitmap(File.DirAssets,"icons8_Full_Image_64px.png"))
	AS_TabMenuAdvanced1.AddTab("Effects",xui.LoadBitmap(File.DirAssets,"icons8_Invert_Selection_52px.png"),xui.LoadBitmap(File.DirAssets,"icons8_Invert_Selection_52px.png"))
	AS_TabMenuAdvanced1.AddTab("About app",xui.LoadBitmap(File.DirAssets,"icons8_Device_Information_50px.png"),xui.LoadBitmap(File.DirAssets,"icons8_Device_Information_50px.png"))
	AS_TabMenuAdvanced1.Refresh
End Sub

#If B4I
Private Sub B4XPage_Resize (Width As Int, Height As Int)
	xpnl_bottom.SetLayoutAnimated(0,0,Height - B4XPages.GetNativeParent(Me).SafeAreaInsets.Bottom,Width,B4XPages.GetNativeParent(Me).SafeAreaInsets.Bottom)
	AS_TabMenuAdvanced1.mBase.Top = Height - AS_TabMenuAdvanced1.mBase.Height - B4XPages.GetNativeParent(Me).SafeAreaInsets.Bottom
End Sub
#End If

 
	

Private Sub AS_TabMenuAdvanced1_TabClick (Index As Int)
	
	Log("TA: "&Index)
	If Index	= 2 Then
		B4XPages.ShowPage("EditBackgroundPicture_C")
		B4XPages.GetPage("EditBackgroundPicture_C").As(EditBackgroundPicture).FillWidthHeightRatios'(Root)
	Else
		callPanel(Index)
		Sleep(90)
		ToggleDrawerState
	End If
End Sub

#end Region
 

Sub changeProfilePic
	Dim img As B4XBitmap = xui.LoadBitmap(xui.DefaultFolder, "profile.jpg")
	ImageView1User.SetBitmap(util.CreateRoundBitmap(img, ImageView1User.Width))
End Sub
 
Sub changeBackGroudPic
	'If SeekBrightLevel.Value=0 Then SeekBrightLevel.Value= Brightness
	Dim tempBmp As B4XBitmap= xui.LoadBitmapResize(xui.DefaultFolder, "Background.jpg",Panel1AreaShot.Height,Panel1AreaShot.Height,True)
	tempBmp=effects.Brightness(tempBmp, Brightness/100)
 	 
	If Blureffect Then
		tempBmp=effects.Blur(tempBmp)
	End If
	OriginalBmp= tempBmp
	Panel1AreaShot.SetBitmap(tempBmp)
End Sub


Sub formatUI
	Mesage.Color=Colors.Transparent
	Mesage.Text=MyMSG
	Dim cs As CSBuilder
	cs.Initialize.Color(0xff8D9AA6)
	cs.Typeface(Typeface.MATERIALICONS).Size(15).VerticalAlign(3dip).Append(Chr(0xE87E)).Pop.Typeface(Typeface.DEFAULT).Size(14).Append(" 2"&TAB&TAB&TAB).Pop
	cs.Typeface(Typeface.MATERIALICONS).Size(15).VerticalAlign(3dip).Append(Chr(0xE0CB)).Pop.Typeface(Typeface.DEFAULT).Size(14).Append(" 5"&TAB&TAB&TAB).Pop
	cs.Typeface(Typeface.MATERIALICONS).Size(15).VerticalAlign(3dip).Append(Chr(0xE040)).Pop.Typeface(Typeface.DEFAULT).Size(14).Append(" 58"&TAB&TAB&TAB).Pop
	cs.Typeface(Typeface.MATERIALICONS).Size(15).VerticalAlign(3dip).Append(Chr(0xE80D)).Pop.Typeface(Typeface.DEFAULT).Size(14).Append(" ").Pop
	cs.PopAll
	DinamicHeight(16)
End Sub


Sub DinamicHeight(Textsize As Int)
	Mesage.Text=MyMSG
	TsizeValue=Textsize
	Mesage.SetTextSizeAnimated(4,Textsize)
	Mesage.Height=-2
	ViewPos.SetBottom(Mesage,Label1UserName.Height+4%y)
	Panel1Post.Height=util.GetHeightText(Mesage.Text,TsizeValue)+9%y
	Panel1AreaShot.Height=Panel1AreaShot.Width
End Sub

Sub ListenTouchEvent(MyView As View)
	Try
		Dim r As Reflector
		r.Target = MyView
		r.SetOnTouchListener("View_Touch")
	Catch
		Log(LastException)
	End Try
	
End Sub

Sub View_Touch(ViewTag As Object, Action As Int, X As Float, Y As Float, MotionEvent As Object) As Boolean
	Select Action
		Case 0 ' DOWN
			' We memorize the starting position
			StartX = X
			StartY = Y
		Case 1 ' UP
		Case 2 ' MOVE
			' Is the move big enough to be considered as a move ?
			If Abs(X - StartX) > 15 Or Abs(Y - StartY) > 15 Then
				' We move the panel
				'BottomPanel.Left = BottomPanel.Left + X - StartX
				Panel1Post.Top = Panel1Post.Top + Y - StartY
				If Sender <> Panel1Post Then
					' We cancel the click on the button/edittext
					Dim r As Reflector
					r.Target = Sender
					r.runmethod2("setPressed","false","java.lang.boolean")
				End If
				Return True ' We trap the Touch event
			End If
	End Select
	If Sender = Panel1Post Then Return True
End Sub


'Private Sub Mesage_TextChanged (Old As String, New As String)
'	DinamicHeight
'End Sub

Private Sub B4XPage_PermissionResult (Permission As String, Result As Boolean)
	Log(Permission)
	Log(Result)
	
End Sub


Private Sub Label2Menu_Options_Click
	B4XPages.GetPage("Saved_C").As(saved).filename =Rnd(100,999)&"_AC_Quote.png"
	Dim Out As OutputStream
	Out = File.OpenOutput(xui.DefaultFolder, B4XPages.GetPage("Saved_C").As(saved).filename, False)
	Panel1AreaShot.Snapshot.WriteToStream(Out, 100, "PNG")
	Out.Close
	Sleep(15)
	B4XPages.ShowPage("Saved_C")
End Sub


#region overlayPOPUP
Sub callPanel(id As Int)
	Overlay = xui.CreatePanel("overlay")
	Overlay.Visible = False
	Dim p As Panel = Overlay
	p.Elevation = 5dip
	Root.AddView(Overlay, 0, 0, 100%x, 100%y)
	Overlay.LoadLayout("overlay")
	If id=0 Then
		pnlBottom.Height=120dip
		pnlBottom.LoadLayout("budget")
		B4XSwitch1budget.Value = budgetValue
	else If id=1 Then
		pnlBottom.Height=200dip
		pnlBottom.LoadLayout("editLayout")
		defaultSeekValues
		checkTextsValue
	else If id=3 Then
		pnlBottom.Height=200dip
		pnlBottom.LoadLayout("editbackgroundEffect")
		checkTextsValueBackGroudPic
	else If id=4 Then
		pnlBottom.Height=120dip
		pnlBottom.LoadLayout("about")
	Else
	End If
	pnlBottom.SetColorAndBorder(xui.Color_White, 0, 0, 15dip)
End Sub





Sub ToggleDrawerState
	Dim Duration As Int = 300
	OverlayVisible = Not(OverlayVisible)
	Overlay.SetVisibleAnimated(Duration, OverlayVisible)
	Dim pnlBottomVisibleHeight As Int = pnlBottom.Height - 8dip 'hide bottom round corners
	If OverlayVisible Then
		pnlBottom.SetLayoutAnimated(0, 0, pnlBottom.Parent.Height, pnlBottom.Width, pnlBottom.Height)
		pnlBottom.SetLayoutAnimated(Duration, 0, pnlBottom.Parent.Height - pnlBottomVisibleHeight, pnlBottom.Width, pnlBottom.Height)
	Else
		'ime.HideKeyboard
		pnlBottom.SetLayoutAnimated(0, 0, pnlBottom.Parent.Height - pnlBottomVisibleHeight, pnlBottom.Width, pnlBottom.Height)
		pnlBottom.SetLayoutAnimated(Duration, 0, pnlBottom.Parent.Height, pnlBottom.Width, pnlBottom.Height)
	End If
End Sub

Sub btn_Click
	ToggleDrawerState
	'px = dp * (dpi / 160)
End Sub
Sub Overlay_Click
	'If OverlayVisible = False Then Return
	ToggleDrawerState
End Sub

Private Sub Label3Close_Click	
	ToggleDrawerState
	AS_TabMenuAdvanced1.Refresh
End Sub
#End region
 
Private Sub B4XSwitch1budget_ValueChanged (Value As Boolean)
	budgetValue=Value
	checkbudgetValue
End Sub
Private Sub checkbudgetValue
	MyName =MyName&" "
	MyName=MyName.Replace("  "," ")
	Dim cs As CSBuilder
	Dim bmp As B4XBitmap = xui.LoadBitmap(File.DirAssets, "icons8_Approval_24px.png")
	Dim bmp1 As B4XBitmap = xui.LoadBitmap(File.DirAssets, "semBudte.png")
	cs.Initialize.Color(0xFFFFFFFF).Bold.Size(17).Append(MyName&"").pop.Image(bmp, 20dip, 20dip, False).Color(0xff8CA7B2).Size(15).Append(CRLF&UserName).PopAll
	If budgetValue = False Then
		cs.Initialize.Color(0xFFFFFFFF).Bold.Size(17).Append(MyName&"").pop.Image(bmp1, 20dip, 20dip, False).Color(0xff8CA7B2).Size(15).Append(CRLF&UserName).PopAll
	End If
	If Label1UserName.IsInitialized Then Label1UserName.text=cs
	If Label1UserName.IsInitialized Then Label1UserName.Width=-2
	If Label1UserName.IsInitialized Then util.Spaceing(Label1UserName,0.99)
End Sub

#Region EditLayout
Private Sub defaultSeekValues
	B4XSeekBar1trasparece.Value=TraspareceValue
	BorderRadius.Value=RadiusValue
	BarTsize.Value=TsizeValue
	Panel1Post.Color=colorBackGroud
End Sub

Private Sub checkTextsValueBackGroudPic
	Dim Brightnesst As Int =Brightness/100
	If Brightnesst=-1 Then Brightnesst=1
	SeekBrightLevel.Value=Brightness
	Dim perceBrightness As Int =100*(SeekBrightLevel.Value/100)
	If Label1Brightness.IsInitialized Then	Label1Brightness.Text=$"Brightness level: ${perceBrightness}%"$
	B4XSwitch1Blureffect.Value=Blureffect
End Sub



Private Sub checkTextsValue
	Label1Radius.Text=$"Border Radius: ${RadiusValue}"$
	Dim perce As Int =100*(TraspareceValue/255)
	Label3Transparent.Text=$"Transparent level: ${perce}%"$
	Label2Tsize.Text=$"Text Size: ${TsizeValue}"$
End Sub

Private Sub BorderRadius_ValueChanged (Value As Int)
	Panel1Post.SetColorAndBorder(Panel1Post.Color, 0, 0,Value*2dip)
	RadiusValue=Value
	checkTextsValue
End Sub

Private Sub B4XSeekBar1trasparece_ValueChanged (Value As Int)
	TraspareceValue=Value
	If Value>90 Then
		colorBackGroud=util.MakeTransparent(0xfFF17212D,TraspareceValue)
		Panel1Post.Color=colorBackGroud
	Else
		colorBackGroud=util.MakeTransparent(0xfFF17212D,90)
		Panel1Post.Color=colorBackGroud
	End If
	checkTextsValue
End Sub

Private Sub BarTsize_ValueChanged (Value As Int)
	Mesage.SetTextSizeAnimated(4,Value)
	DinamicHeight(Value)
	checkTextsValue
End Sub


#End Region

 

Private Sub Mesage_Click
	Dim sf As Object = DetailsDialog.ShowAsync("", "", "", "", Null, True)
	DetailsDialog.SetSize(95%x, 390dip)
	Wait For (sf) Dialog_Ready(pnl As Panel)
	pnl.LoadLayout("TextingUI")
	EditText1Msg.Text=MyMSG
	EditText1Msg.SelectAll
	pnl.Color =0xFF17212D
	EditText1Msg.InputType = Bit.Or(0x00002000, EditText1Msg.InputType)
	EditText1Msg.Color=Colors.Transparent
	Sleep(12)
	EditText1Msg.SelectAll
	Wait For (sf) Dialog_Result(res As Int)
	If res = DialogResponse.POSITIVE Then
		Dim MyMSG As String=EditText1Msg.Text
		Sleep(9)
		DinamicHeight(16)
	End If
End Sub

Private Sub Panel3ISelect_Click
	
End Sub



Private Sub ImageView1User_Click
	Log("ImageView1User_Click")
	B4XPages.ShowPage("editProfilePicture_C")
	B4XPages.GetPage("editProfilePicture_C").As(editProfilePicture).FillWidthHeightRatios'(Root)
'	B4XPages.GetPage("menu").As(menu_C).btnLoadImage_Click'(Root)
End Sub

Private Sub Label1UserName_Click
	Dim sf As Object = DetailsDialog.ShowAsync("", "", "", "", Null, True)
	DetailsDialog.SetSize(95%x, 390dip)
	Wait For (sf) Dialog_Ready(pnl As Panel)
	pnl.LoadLayout("DetailsDialog")
	EditText1name.Text=MyName
	EditText2username.Text=UserName.ToLowerCase
	pnl.Color =0xFF17212D
	EditText1name.Color=Colors.Transparent
	EditText2username.Color=Colors.Transparent
	EditText2username.InputType = Bit.Or(0x00002000, EditText2username.InputType)
	EditText1name.InputType = Bit.Or(0x00002000, EditText1name.InputType)
	Wait For (sf) Dialog_Result(res As Int)
	Dim p As Phone
	p.HideKeyboard(Root)
	If res = DialogResponse.POSITIVE Then
		Dim MyName As String=EditText1name.Text
		Dim UserName As String="@"&EditText2username.Text.ToLowerCase
		UserName=UserName.Replace("@@","@")
		Sleep(9)
		checkbudgetValue
	End If
End Sub
 

Private Sub SeekBrightLevel_ValueChanged (Value As Int)
	Brightness=Value
	checkTextsValueBackGroudPic
	changeBackGroudPic
End Sub

 
Private Sub Button2Save_Click
	If EditText1name.Text="" Or EditText2username.Text ="@" Or EditText2username.Text="" Then
	Else
		DetailsDialog.CloseDialog(DialogResponse.POSITIVE)
	End If
End Sub

Private Sub Button1Cancel_Click
	DetailsDialog.CloseDialog(DialogResponse.CANCEL)
End Sub

Private Sub B4XSwitch1Blureffect_ValueChanged (Value As Boolean)
	Blureffect=Value
	checkTextsValueBackGroudPic
	changeBackGroudPic
End Sub

Private Sub Button2SaveMSG_Click
	DetailsDialog.CloseDialog(DialogResponse.POSITIVE)
End Sub





