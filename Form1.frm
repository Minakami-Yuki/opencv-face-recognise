VERSION 5.00
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   9840
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   17100
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   656
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   1140
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '屏幕中心
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const ULW_OPAQUE = &H4
Private Const ULW_COLORKEY = &H1
Private Const ULW_ALPHA = &H2
Private Const BI_RGB As Long = 0&
Private Const DIB_RGB_COLORS As Long = 0
Private Const AC_SRC_ALPHA As Long = &H1
Private Const AC_SRC_OVER = &H0
Private Const WS_EX_LAYERED = &H80000
Private Const GWL_STYLE As Long = -16
Private Const GWL_EXSTYLE As Long = -20
Private Const HWND_TOPMOST As Long = -1
Private Const SWP_NOMOVE As Long = &H2
Private Const SWP_NOSIZE As Long = &H1

Private Type BLENDFUNCTION
    BlendOp As Byte
    BlendFlags As Byte
    SourceConstantAlpha As Byte
    AlphaFormat As Byte
End Type

Private Type Size
    cx As Long
    cy As Long
End Type

Private Type POINTAPI
    x As Long
    y As Long
End Type

Private Type RGBQUAD
    rgbBlue As Byte
    rgbGreen As Byte
    rgbRed As Byte
    rgbReserved As Byte
End Type

Private Type BITMAPINFOHEADER
    biSize As Long
    biWidth As Long
    biHeight As Long
    biPlanes As Integer
    biBitCount As Integer
    biCompression As Long
    biSizeImage As Long
    biXPelsPerMeter As Long
    biYPelsPerMeter As Long
    biClrUsed As Long
    biClrImportant As Long
End Type

Private Type BITMAPINFO
    bmiHeader As BITMAPINFOHEADER
    bmiColors As RGBQUAD
End Type

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Declare Function BitBlt Lib "gdi32.dll" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function AlphaBlend Lib "Msimg32.dll" (ByVal hdcDest As Long, ByVal nXOriginDest As Long, ByVal lnYOriginDest As Long, ByVal nWidthDest As Long, ByVal nHeightDest As Long, ByVal hdcSrc As Long, ByVal nXOriginSrc As Long, ByVal nYOriginSrc As Long, ByVal nWidthSrc As Long, ByVal nHeightSrc As Long, ByVal bf As Long) As Boolean
Private Declare Function UpdateLayeredWindow Lib "user32.dll" (ByVal hwnd As Long, ByVal hdcDst As Long, pptDst As Any, psize As Any, ByVal hdcSrc As Long, pptSrc As Any, ByVal crKey As Long, ByRef pblend As BLENDFUNCTION, ByVal dwFlags As Long) As Long
Private Declare Function CreateDIBSection Lib "gdi32.dll" (ByVal hdc As Long, pBitmapInfo As BITMAPINFO, ByVal un As Long, ByRef lplpVoid As Any, ByVal handle As Long, ByVal dw As Long) As Long
Private Declare Function GetDIBits Lib "gdi32.dll" (ByVal aHDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As BITMAPINFO, ByVal wUsage As Long) As Long
Private Declare Function SetDIBits Lib "gdi32.dll" (ByVal hdc As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As BITMAPINFO, ByVal wUsage As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32.dll" (ByVal hdc As Long) As Long
Private Declare Function SelectObject Lib "gdi32.dll" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteDC Lib "gdi32.dll" (ByVal hdc As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32.dll" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Private Declare Function SetWindowPos Lib "user32.dll" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Private Declare Function GetWindowLong Lib "user32.dll" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Private Declare Function GetDC Lib "user32.dll" (ByVal hwnd As Long) As Long

Dim mDC As Long
Dim mainBitmap As Long
Dim blendFunc32bpp As BLENDFUNCTION
Dim token As Long
Dim oldBitmap As Long
Dim x1, y1 As Integer
Private Declare Function MessageBoxTimeout Lib "user32" Alias "MessageBoxTimeoutA" (ByVal hwnd As Long, ByVal lpText As String, ByVal lpCaption As String, ByVal wType As Long, ByVal wlange As Long, ByVal dwTimeout As Long) As Long

Private Sub Form_Activate()
Sleep 500 'ms
'MessageBoxTimeout Me.hwnd, "正在检查必要文件", "请稍等", vbInformation, 0, 3000
'CreateObject("Wscript.Shell").Popup "本窗口将在三秒钟后自动关闭……", 3, "MsgBox", 64
'MsgBox "正在检查所需文件", , "稍等片刻"//有问题，会卡死
'Label1.Caption = "正在检查运行所需文件，请稍等片刻aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
   If Dir(App.Path & "\预处理.exe") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\模型训练.exe") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\拍照.exe") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\识别.exe") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\haarcascade_frontalface_alt2.xml") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\haarcascade_frontalface_default.xml") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\AY_sys10.wav") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\AY_sys11.wav") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\NA_sys2.wav") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\NA_sys10.wav") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\1.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\2.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\3.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\4.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\5.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\6.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\7.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\8.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\9.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
   If Dir(App.Path & "\10.png") = "" Then
   checkerror.Show
   Unload Me
   Exit Sub
   End If
'Sleep 2000 'ms
main.Show
'checkerror.Show
Unload Me '这里必须用me？？？？？？？？？？？？？
End Sub

Private Sub Form_DblClick()

    Unload Me

End Sub

Private Sub Form_Load()

    Dim GpInput As GdiplusStartupInput
    GpInput.GdiplusVersion = 1
   
    If GdiplusStartup(token, GpInput) <> 0 Then
        MsgBox "Fehler bem laden von GDI+!", vbCritical
        Unload Me
    End If
    
    MakeTrans (App.Path & "\loading.png")
   'MakeTrans (App.Path & "\main.png")
   
'   Label1.Caption = "正在检查运行所需文件，请稍等片刻aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
'    Sleep 1000 'ms
'    main.Show
'    Me.Hide '这里必须用me？？？？？？？？？？？？？
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
x1 = x: y1 = y
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
If Button = 1 Then
Me.Left = Me.Left + x - x1
Me.Top = Me.Top + y - y1
End If


End Sub

Private Sub Form_Unload(Cancel As Integer)
    
    Call GdiplusShutdown(token)
    SelectObject mDC, oldBitmap
    DeleteObject mainBitmap
    DeleteObject oldBitmap
    DeleteDC mDC

End Sub

Private Function MakeTrans(pngPath As String) As Boolean

   Dim tempBI As BITMAPINFO
   Dim tempBlend As BLENDFUNCTION
   Dim lngHeight As Long, lngWidth As Long
   Dim curWinLong As Long
   Dim img As Long
   Dim graphics As Long
   Dim winSize As Size
   Dim srcPoint As POINTAPI
   
   With tempBI.bmiHeader
      .biSize = Len(tempBI.bmiHeader)
      .biBitCount = 32
      .biHeight = Me.ScaleHeight
      .biWidth = Me.ScaleWidth
      .biPlanes = 1
      .biSizeImage = .biWidth * .biHeight * (.biBitCount / 8)
   End With
   mDC = CreateCompatibleDC(Me.hdc)
   mainBitmap = CreateDIBSection(mDC, tempBI, DIB_RGB_COLORS, ByVal 0, 0, 0)
   oldBitmap = SelectObject(mDC, mainBitmap)
    
   Call GdipCreateFromHDC(mDC, graphics)
   Call GdipLoadImageFromFile(StrConv(pngPath, vbUnicode), img)
   Call GdipGetImageHeight(img, lngHeight)
   Call GdipGetImageWidth(img, lngWidth)
   Call GdipDrawImageRect(graphics, img, 0, 0, lngWidth, lngHeight)

   curWinLong = GetWindowLong(Me.hwnd, GWL_EXSTYLE)
   
   SetWindowLong Me.hwnd, GWL_EXSTYLE, curWinLong Or WS_EX_LAYERED
   SetWindowPos Me.hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
   
   srcPoint.x = 0
   srcPoint.y = 0
   winSize.cx = Me.ScaleWidth
   winSize.cy = Me.ScaleHeight
    
   With blendFunc32bpp
      .AlphaFormat = AC_SRC_ALPHA
      .BlendFlags = 0
      .BlendOp = AC_SRC_OVER
      .SourceConstantAlpha = 255
   End With
    
   Call GdipDisposeImage(img)
   Call GdipDeleteGraphics(graphics)
   Call UpdateLayeredWindow(Me.hwnd, Me.hdc, ByVal 0&, winSize, mDC, srcPoint, 0, blendFunc32bpp, ULW_ALPHA)
   
End Function

