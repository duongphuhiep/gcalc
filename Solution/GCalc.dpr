program GCalc;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  UVarDlg in 'UVarDlg.pas' {Form2},
  UGrDlg in 'UGrDlg.pas' {Form3},
  UCommon in 'UCommon.pas',
  UWndDraw in 'UWndDraw.pas' {Form4},
  UPaint in 'UPaint.pas',
  UZoom in 'UZoom.pas' {Form5},
  UOrg in 'UOrg.pas' {Form6},
  UBgr in 'UBgr.pas' {Form7},
  UFastInfo in 'UFastInfo.pas' {Form8},
  U_ptb2 in 'U_ptb2.pas' {Form_gptb2},
  U_ptb3 in 'U_ptb3.pas' {Form_ptb3},
  U_ptyfx in 'U_ptyfx.pas' {Form_yfx},
  U_hpt2 in 'U_hpt2.pas' {Form_hpt2},
  U_hpt3 in 'U_hpt3.pas' {Form_hpt3},
  U_xfx in 'U_xfx.pas' {Form_xfx},
  U_doi_ps in 'U_doi_ps.pas' {Form_frac},
  U_splash in 'U_splash.pas' {SplashForm},
  Dialogs in 'Dialogs.pas',
  Buttons in 'Buttons.pas',
  U_Matran in 'U_Matran.pas' {frm_matrix},
  matrix in 'matrix.PAS',
  U_CUnit in 'U_CUnit.pas' {frm_cvunit};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'General Calculator';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm_gptb2, Form_gptb2);
  Application.CreateForm(TForm_ptb3, Form_ptb3);
  Application.CreateForm(TForm_yfx, Form_yfx);
  Application.CreateForm(TForm_hpt2, Form_hpt2);
  Application.CreateForm(TForm_hpt3, Form_hpt3);
  Application.CreateForm(TForm_xfx, Form_xfx);
  Application.CreateForm(TForm_frac, Form_frac);
  Application.CreateForm(TSplashForm, SplashForm);
  Application.CreateForm(Tfrm_matrix, frm_matrix);
  Application.CreateForm(Tfrm_cvunit, frm_cvunit);
  Application.Run;
end.
