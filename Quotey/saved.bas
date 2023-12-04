B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.8
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Dim filename As String=""
	Private Panel1AreaShot As B4XView
	Private ion As Object
	Private Panel1Saved As B4XView
	Public Provider As FileProvider
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("SavedUI")	
	Provider.Initialize
End Sub

 
Sub B4XPage_Appear
	If File.Exists(xui.DefaultFolder, filename) Then
		Dim img As B4XBitmap= xui.LoadBitmapResize(xui.DefaultFolder, filename,Panel1AreaShot.Height,Panel1AreaShot.Height,True)
		Panel1AreaShot.SetBitmap(img)
	End If
End Sub
 

Private Sub Label1Back_Click
	B4XPages.GetPage("create").As(create).B4XPage_Appear
	B4XPages.ShowPageAndRemovePreviousPages("create")
	B4XPages.ClosePage(Me)
End Sub

Sub SaveFile (Source As InputStream, MimeType As String, Title As String) As ResumableSub
	Dim intent As Intent
	intent.Initialize("android.intent.action.CREATE_DOCUMENT", "")
	intent.AddCategory("android.intent.category.OPENABLE")
	intent.PutExtra("android.intent.extra.TITLE", Title)
	intent.SetType(MimeType)
	StartActivityForResult(intent)
	Wait For ion_Event (MethodName As String, Args() As Object)
	If -1 = Args(0) Then 'resultCode = RESULT_OK
		Dim result As Intent = Args(1)
		Dim jo As JavaObject = result
		Dim ctxt As JavaObject
		Dim out As OutputStream = ctxt.InitializeContext.RunMethodJO("getContentResolver", Null).RunMethod("openOutputStream", Array(jo.RunMethod("getData", Null)))
		File.Copy2(Source, out)
		out.Close
		Return True
	End If
	Return False
End Sub

Sub StartActivityForResult(i As Intent)
	Dim jo As JavaObject = GetBA
	ion = jo.CreateEvent("anywheresoftware.b4a.IOnActivityResult", "ion", Null)
	jo.RunMethod("startActivityForResult", Array(ion, i))
End Sub

Sub GetBA As Object
	Dim jo As JavaObject = Me
	Return jo.RunMethod("getBA", Null)
End Sub


Private Sub Button1Save_Click
	Wait For (SaveFile(File.OpenInput(xui.DefaultFolder, filename), "application/octet-stream", filename)) Complete (Success As Boolean)
	Log("File saved successfully? " & Success)
	
	If Success Then
		Panel1Saved.SetVisibleAnimated(666,True)
		Sleep(999)
		Panel1Saved.SetVisibleAnimated(666,False)
	End If
End Sub

Private Sub Panel1Saved_Click
	Panel1Saved.SetVisibleAnimated(666,False)
End Sub

Private Sub Button1Share_Click
	Dim FileToSend As String = filename
	Wait For (File.CopyAsync(xui.DefaultFolder, filename, Provider.SharedFolder, filename)) Complete (Success As Boolean)
	Log("Success: " & Success)
	Dim in As Intent
	in.Initialize(in.ACTION_SEND, "")
	in.SetType("image/*")
	in.PutExtra("android.intent.extra.STREAM", Provider.GetFileUri(FileToSend))
	in.Flags = 1 'FLAG_GRANT_READ_URI_PERMISSION
	StartActivity(in)
End Sub