B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=6.01
@EndOfDesignText@
' ViewPos - Code module

Sub Process_Globals
	Private xui As XUI 'ignore
	Type tLocation(Left As Int, Top As Int)
End Sub


#Region GET FUNCTIONS 

' Returns the bottom position of Vw.
Public Sub GetBottom(Vw As B4XView) As Int
	Return Vw.Top + Vw.Height - 1
End Sub
' Returns the right position of Vw.
Public Sub GetRight(Vw As B4XView) As Int
	Return Vw.Left + Vw.Width - 1
End Sub

#If B4A
' Returns the absolute position of Vw on screen.
Public Sub GetLocation(Vw As View) As tLocation
	Dim Location As tLocation
	Location.Initialize
	
	Dim leftTop(2) As Int
	Dim JO As JavaObject = Vw
	JO.RunMethod("getLocationOnScreen", Array As Object(leftTop))
	Location.Left = leftTop(0)
	Location.Top = leftTop(1)
	
	Return Location
End Sub

#Else If B4J

' Returns the absolute position of Vw on screen.
Public Sub GetLocation(Vw As B4XView) As tLocation
	Dim Location As tLocation
	Location.Initialize

	Dim Jo1 As JavaObject = Sender
	Dim objBoundsInScreen As Object = Jo1.RunMethod("getBoundsInLocal", Null)
	Dim joLocalToScreen As JavaObject = Jo1.RunMethod("localToScreen", Array As Object(objBoundsInScreen))
  
	Location.Left = joLocalToScreen.RunMethod("getMinX", Null)
	Location.Top = joLocalToScreen.RunMethod("getMinY", Null)
	
	Return Location
End Sub

#Else ' B4I

' Returns the absolute position of Vw on screen.
Public Sub GetLocation(Vw As B4XView) As tLocation
	Dim Location As tLocation
	Location.Initialize
	Dim x, y As Int
	Dim parent As B4XView = view

	Try
		Do While parent.IsInitialized
			x = x + parent.Left
			y = y + parent.Top
			parent = parent.Parent
		Loop
		Location.Left = x
		Location.Top = y
	Catch
		Log(LastException)
	End Try

	Return Location
End Sub

#End If


#End Region


#Region POSITIONING METHODS 

' Sets the right position of Vw.
Public Sub SetRight(Vw As B4XView, Right As Int)
	Vw.Left = Right - Vw.Width
End Sub
' Sets the bottom position of Vw.
Public Sub SetBottom(Vw As B4XView, Bottom As Int)
	Vw.Top = Bottom - Vw.Height
End Sub

' Sets the right position of Vw with animation.
Public Sub SetRightAnim(Duration As Int, Vw As B4XView, Right As Int)
	Vw.SetLayoutAnimated(Duration, Right - Vw.Width, Vw.Top, Vw.Width, Vw.Height)
End Sub
' Sets the bottom position of Vw with animation.
Public Sub SetBottomAnim(Duration As Int, Vw As B4XView, Bottom As Int)
	Vw.SetLayoutAnimated(Duration, Vw.Left, Bottom - Vw.Height, Vw.Width, Vw.Height)
End Sub



' Sets the bottom position of ViewToMove on top of RelativeView, spaced of VertDistance.
Public Sub SetRelBottom(ViewToMove As B4XView, RelativeView As B4XView, VertDistance As Int)
	ViewToMove.Top = RelativeView.Top - ViewToMove.Height - VertDistance
End Sub
' Sets the right position of ViewToMove on left of RelativeView, spaced of HorDistance.
Public Sub SetRelRight(ViewToMove As B4XView, RelativeView As B4XView, HorDistance As Int)
	ViewToMove.Left = RelativeView.Left - ViewToMove.Width - HorDistance
End Sub

' Sets the bottom position of ViewToMove on top of RelativeView, spaced of VertDistance, with animation.
Public Sub SetRelBottomAnim(Duration As Int, ViewToMove As B4XView, RelativeView As B4XView, VertDistance As Int)
	ViewToMove.SetLayoutAnimated(Duration, ViewToMove.Left, RelativeView.Top - ViewToMove.Height - VertDistance, ViewToMove.Width, ViewToMove.Height)
End Sub
' Sets the right position of ViewToMove on left of RelativeView, spaced of HorDistance, with animation.
Public Sub SetRelRightAnim(Duration As Int, ViewToMove As B4XView, RelativeView As B4XView, HorDistance As Int)
	ViewToMove.SetLayoutAnimated(Duration, RelativeView.Left - ViewToMove.Width - HorDistance, ViewToMove.Top, ViewToMove.Width, ViewToMove.Height)
End Sub



' Centers vertically ViewToPlace between TopView and BottomView.
Public Sub VerCenterBetween(ViewToPlace As B4XView, TopView As B4XView, BottomView As B4XView)
' USES: Function GetBottom.
	Dim TopViewBottom As Int = GetBottom(TopView)
	ViewToPlace.Top = TopViewBottom + (BottomView.Top - TopViewBottom - ViewToPlace.Height) / 2
End Sub
' Centers horizontally ViewToPlace between LeftView and RightView.
Public Sub HorCenterBetween(ViewToPlace As B4XView, LeftView As B4XView, RightView As B4XView)
' USES: Function GetRight
	Dim SpaceBetween As Int = RightView.Left - GetRight(LeftView)
	Dim NewLeft As Int
	NewLeft = GetRight(LeftView) + (SpaceBetween - ViewToPlace.Width) / 2
	ViewToPlace.Left = NewLeft
End Sub

' Centers vertically ViewToPlace between TopView and BottomView, with animation.
Public Sub VerCenterBetweenAnim(Duration As Int, ViewToPlace As B4XView, TopView As B4XView, BottomView As B4XView)
' USES: Function GetBottom.
	Dim TopViewBottom As Int = GetBottom(TopView)
	ViewToPlace.SetLayoutAnimated(Duration, ViewToPlace.Left, TopViewBottom + (BottomView.Top - TopViewBottom - ViewToPlace.Height) / 2, ViewToPlace.Width, ViewToPlace.Height)
End Sub
' Centers horizontally ViewToPlace between LeftView and RightView, wth animation.
Public Sub HorCenterBetweenAnim(Duration As Int, ViewToPlace As B4XView, LeftView As B4XView, RightView As B4XView)
' USES: Function GetRight
	Dim SpaceBetween As Int = RightView.Left - GetRight(LeftView)
	Dim NewLeft As Int
	NewLeft = GetRight(LeftView) + (SpaceBetween - ViewToPlace.Width) / 2
	ViewToPlace.SetLayoutAnimated(Duration, NewLeft, ViewToPlace.Top, ViewToPlace.Width, ViewToPlace.Height)
End Sub

#End Region