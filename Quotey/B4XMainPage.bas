B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#End Region
Sub Class_Globals
	Dim util As Utilities
	Public Root As B4XView
	Private xui As XUI
	'CREATE PAGES
	Dim editProfilePicture_C As editProfilePicture
	Dim EditBackgroundPicture_C As EditBackgroundPicture
	Dim Create_C As create
	Dim saved_C As saved
End Sub

Public Sub Initialize
	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Public Sub B4XPage_Created (Root1 As B4XView)
'	Dim r As RuntimePermissions
'	r.CheckAndRequest(r.PERMISSION_WRITE_EXTERNAL_STORAGE)
'	r.CheckAndRequest(r.PERMISSION_READ_EXTERNAL_STORAGE)
	Root = Root1	 
	util.Initialize
	editProfilePicture_C.Initialize
	EditBackgroundPicture_C.Initialize
	saved_C.Initialize
	Create_C.Initialize
	B4XPages.AddPageAndCreate("editProfilePicture_C",editProfilePicture_C)
	B4XPages.AddPageAndCreate("EditBackgroundPicture_C",EditBackgroundPicture_C)
	B4XPages.AddPageAndCreate("Saved_C",saved_C)
	B4XPages.AddPageAndCreate("create",Create_C)
	Sleep(999)
	B4XPages.ShowPageAndRemovePreviousPages("create")
	
End Sub
