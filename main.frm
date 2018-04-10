VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form main 
   BackColor       =   &H80000005&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "main"
   ClientHeight    =   2490
   ClientLeft      =   150
   ClientTop       =   795
   ClientWidth     =   3630
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2490
   ScaleWidth      =   3630
   StartUpPosition =   3  '窗口缺省
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   120
      Top             =   720
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label Label1 
      BackColor       =   &H80000005&
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "华康少女文字W5(P)"
         Size            =   12
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2775
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   2415
   End
   Begin VB.Image Image1 
      Height          =   2970
      Left            =   2640
      Picture         =   "main.frx":0000
      Top             =   0
      Width           =   1275
   End
   Begin VB.Menu new 
      Caption         =   "新的人物"
      Begin VB.Menu shot 
         Caption         =   "照片采集"
      End
      Begin VB.Menu pre 
         Caption         =   "预处理"
      End
      Begin VB.Menu train 
         Caption         =   "模型训练"
      End
   End
   Begin VB.Menu load 
      Caption         =   "载入现有模型"
      Begin VB.Menu open 
         Caption         =   "打开"
      End
   End
   Begin VB.Menu start 
      Caption         =   "开始识别"
      Begin VB.Menu begin 
         Caption         =   "确认开始"
      End
   End
End
Attribute VB_Name = "main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub begin_Click()
If Dir(App.Path & "\my_face_test.xml") = "" Then
checkerror.Show
Unload Me
Exit Sub
End If
If MsgBox("程序会在即将打开的窗口进行，按下‘q’键停止", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\识别.exe")
End If
Label1.Caption = "结果保存在result.txt文件中"
End Sub

Private Sub Form_Load()
Label1.Caption = "欢迎！" & Chr$(10) & Chr$(10) & "请从上方选择一项开始"
'Label1.Caption = App.Path
End Sub

Private Sub open_Click()
CommonDialog1.Filter = "All Files (*.*)|*.*|Xml Files (*.xml)|*.xml"
'指定缺省过滤器。
CommonDialog1.FilterIndex = 2
'显示“打开”对话框。
CommonDialog1.ShowOpen
'调用打开文件的过程。
'Label1.Caption = App.Path & "1.xml"

If filename = "" Then Exit Sub

FileCopy CommonDialog1.filename, App.Path & "\my_face_test.xml"
Label1.Caption = CommonDialog1.filename
'FileCopy CommonDialog1.filename, App.Path & "\"
Label1.Caption = "模型载入完成！" & Chr$(10) & "可以开始识别了"
'OpenFile (CommonDialog1.filename)
Exit Sub
ErrHandler:
'用户按“取消”按钮。
Exit Sub

End Sub

Private Sub pre_Click()
If MsgBox("接下来会对照片的面部进行采集，程序完成后会自动退出，请耐心等待", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\预处理.exe")
End If
Label1.Caption = "接下来需要训练模型"
End Sub

Private Sub shot_Click()
If MsgBox("请在接下来的窗口中，保持面部居中，按下键盘上p键拍照，共需10次", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\拍照.exe")
End If
Label1.Caption = "接下来需要对拍下的图片进行预处理"
End Sub

Private Sub train_Click()
If MsgBox("程序正在训练模型，程序完成后会自动退出，请耐心等待", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\模型训练.exe")
End If
Label1.Caption = "现在可以开始识别了"
End Sub
