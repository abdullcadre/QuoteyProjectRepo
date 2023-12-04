B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.8
@EndOfDesignText@
 
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI

	Private ImageDir, ImageFileName As String
#If B4A
	Public Chooser As ContentChooser
#Else If B4i
#Else If B4J
	Private Chooser As FileChooser
#End If
	
	Private xResizeAndCrop1 As xResizeAndCrop
	
'	Private pnlCroppedImage, pnlCustomRatio, pnlRoundCorners As B4XView
'	Private cbxWidthHeightRatio As B4XComboBox
'	Private edtWidthHeightRatioValue, lblRoundCorners As B4XView
'	Private swtRoundCorners As B4XSwitch
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
public  Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("Main")
	Sleep(90)
	FillWidthHeightRatios
End Sub





Public  Sub FillWidthHeightRatios
	
	If File.Exists( xui.DefaultFolder, "Background.jpg")  Then
		xResizeAndCrop1.LoadImage(xui.DefaultFolder, "Background.jpg")
	Else
		Wait For (File.CopyAsync(File.DirAssets, "img2.jpg", xui.DefaultFolder, "Background.jpg")) Complete (Success As Boolean)
		Log("Success: " & Success)
		xResizeAndCrop1.LoadImage(File.DirAssets, "img2.jpg")
		
	End If
	
	
'	xResizeAndCrop1.CroppedView = pnlCroppedImage
'	xResizeAndCrop1.RoundCorners = True
'	xResizeAndCrop1.CornerRadius = 95
#If B4A
#Else If B4i
#Else If B4J
	Chooser.Initialize
#End If
	
	
	
'	edtWidthHeightRatioValue .Text = xResizeAndCrop1.WidthHeightRatioValue
'	lblRoundCorners.Text = xResizeAndCrop1.CornerRadius
'	swtRoundCorners.Value = xResizeAndCrop1.RoundCorners
'	If xResizeAndCrop1.WidthHeightRatio = "Circle" Then
'		pnlRoundCorners.Visible = False
'	Else
'		pnlRoundCorners.Visible = True
'	End If
	xResizeAndCrop1.WidthHeightRatioValue = 5
	xResizeAndCrop1.WidthHeightRatio = "Square"
End Sub

Public  Sub btnLoadImage_Click
	'Private n As Int
#If B4A
	Chooser.Initialize("Chooser")
	Chooser.Show("image/*", "Select an image")
#Else If B4i
#Else If B4J
	Private lstExtensions As List
	lstExtensions.Initialize2(Array As String("*.bmp", "*.jpg", "*.png"))
	Chooser.SetExtensionFilter("Image files", lstExtensions)
	Chooser.Title = "Select an image file"
	ImageFileName = Chooser.ShowOpen(Main.MainForm)
	If ImageFileName <> "" Then
		Log(ImageFileName)
		n = ImageFileName.LastIndexOf("\")
		ImageDir = ImageFileName.SubString2(0, n)
		ImageFileName = ImageFileName.SubString(n + 1)
		xResizeAndCrop1.LoadImage(ImageDir, ImageFileName)
	End If
#End If
End Sub

Private Sub btnSaveCroppedImage_Click
'	ProgressDialogShow("Waiting...")
	Private Dir, FileName As String
'	xui.SetDataFolder("xResizeAndCropDemo")
	Dir = xui.DefaultFolder
	Log(Dir)
	FileName = "Background.jpg"
	Private Out As OutputStream
	Out = File.OpenOutput(Dir, FileName, False)
	xResizeAndCrop1.CroppedImage.WriteToStream(Out, 100, "JPEG")

	Out.Close
	Try
		B4XPages.ShowPageAndRemovePreviousPages("create")
		B4XPages.ClosePage(Me)
	Catch
		Log(LastException)
	End Try
	

End Sub

Private Sub xResizeAndCrop1_CropFinished
	Log("Crop finished")
End Sub


#If B4A
Private Sub Chooser_Result (Success As Boolean, Dir As String, FileName As String)
	If True Then
		ImageDir = Dir
		ImageFileName = FileName
		xResizeAndCrop1.Image = xui.LoadBitmapResize(ImageDir, ImageFileName, 2000, 2000, True)
	End If
End Sub
#End If


Private Sub Label1Back_Click
	B4XPages.ShowPageAndRemovePreviousPages("create")
	B4XPages.ClosePage(Me)
End Sub