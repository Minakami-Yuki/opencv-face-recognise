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
   StartUpPosition =   3  '����ȱʡ
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
         Name            =   "������Ů����W5(P)"
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
      Caption         =   "�µ�����"
      Begin VB.Menu shot 
         Caption         =   "��Ƭ�ɼ�"
      End
      Begin VB.Menu pre 
         Caption         =   "Ԥ����"
      End
      Begin VB.Menu train 
         Caption         =   "ģ��ѵ��"
      End
   End
   Begin VB.Menu load 
      Caption         =   "��������ģ��"
      Begin VB.Menu open 
         Caption         =   "��"
      End
   End
   Begin VB.Menu start 
      Caption         =   "��ʼʶ��"
      Begin VB.Menu begin 
         Caption         =   "ȷ�Ͽ�ʼ"
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
If MsgBox("������ڼ����򿪵Ĵ��ڽ��У����¡�q����ֹͣ", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\ʶ��.exe")
End If
Label1.Caption = "���������result.txt�ļ���"
End Sub

Private Sub Form_Load()
Label1.Caption = "��ӭ��" & Chr$(10) & Chr$(10) & "����Ϸ�ѡ��һ�ʼ"
'Label1.Caption = App.Path
End Sub

Private Sub open_Click()
CommonDialog1.Filter = "All Files (*.*)|*.*|Xml Files (*.xml)|*.xml"
'ָ��ȱʡ��������
CommonDialog1.FilterIndex = 2
'��ʾ���򿪡��Ի���
CommonDialog1.ShowOpen
'���ô��ļ��Ĺ��̡�
'Label1.Caption = App.Path & "1.xml"

If filename = "" Then Exit Sub

FileCopy CommonDialog1.filename, App.Path & "\my_face_test.xml"
Label1.Caption = CommonDialog1.filename
'FileCopy CommonDialog1.filename, App.Path & "\"
Label1.Caption = "ģ��������ɣ�" & Chr$(10) & "���Կ�ʼʶ����"
'OpenFile (CommonDialog1.filename)
Exit Sub
ErrHandler:
'�û�����ȡ������ť��
Exit Sub

End Sub

Private Sub pre_Click()
If MsgBox("�����������Ƭ���沿���вɼ���������ɺ���Զ��˳��������ĵȴ�", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\Ԥ����.exe")
End If
Label1.Caption = "��������Ҫѵ��ģ��"
End Sub

Private Sub shot_Click()
If MsgBox("���ڽ������Ĵ����У������沿���У����¼�����p�����գ�����10��", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\����.exe")
End If
Label1.Caption = "��������Ҫ�����µ�ͼƬ����Ԥ����"
End Sub

Private Sub train_Click()
If MsgBox("��������ѵ��ģ�ͣ�������ɺ���Զ��˳��������ĵȴ�", vbOKOnly, "tips") = vbOK Then
Shell (App.Path & "\ģ��ѵ��.exe")
End If
Label1.Caption = "���ڿ��Կ�ʼʶ����"
End Sub
