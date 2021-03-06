unit u_frmproveedor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ButtonPanel,
  MaskEdit, ZDataset, LCLType;

type

  { TFrmProveedor }

  TFrmProveedor = class(TForm)
    BP: TButtonPanel;
    Label5: TLabel;
    TxtIdent: TEdit;
    TxtEmpresa: TEdit;
    TxtNombre: TEdit;
    TxtRFC: TEdit;
    TxtEmail: TEdit;
    TxtTelefono: TEdit;
    TxtCelular: TEdit;
    TxtDe: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    TxtDir: TMemo;
    ZQProveedor: TZQuery;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    save:Boolean;

  public
    edit:Boolean;
    prov_id:Integer;

  end;

var
  FrmProveedor: TFrmProveedor;

implementation

{$R *.lfm}

{ TFrmProveedor }

procedure TFrmProveedor.OKButtonClick(Sender: TObject);
begin
  // Validar los datos necesarios
  if TxtEmpresa.Text = '' then
  begin
    Application.MessageBox('Es necesario ingresar el nombre de la empresa',
    'Faltan datos', MB_ICONEXCLAMATION);
    TxtEmpresa.SetFocus;
    save:=false;
    Exit;
  end;

  if (TxtTelefono.Text = '') and (TxtCelular.Text = '') then
  begin
    Application.MessageBox('Es necesario ingresar un teléfono o un celular de contacto',
    'Faltan datos', MB_ICONEXCLAMATION);
    save:=false;
    Exit;
  end;

  if not edit then
  begin
    ZQProveedor.SQL.Text:='insert into proveedores(celular,de,direccion,email,'+
    ' empresa, representante, rfc, telefono, estatus) values(:celular, :de, '+
    ':direccion, :email, :empresa, :representante, :rfc, :telefono, 1)';

    ZQProveedor.Params.ParamByName('celular').AsString:=TxtCelular.Text;
    ZQProveedor.Params.ParamByName('de').AsString:=TxtDe.Text;
    ZQProveedor.Params.ParamByName('direccion').AsString:=TxtDir.Text;
    ZQProveedor.Params.ParamByName('email').AsString:=TxtEmail.Text;
    ZQProveedor.Params.ParamByName('empresa').AsString:=TxtEmpresa.Text;
    ZQProveedor.Params.ParamByName('representante').AsString:=TxtNombre.Text;
    ZQProveedor.Params.ParamByName('rfc').AsString:=TxtRFC.Text;
    ZQProveedor.Params.ParamByName('telefono').AsString:=TxtTelefono.Text;

    ZQProveedor.ExecSQL;
    Application.MessageBox('Proveedor agregado exitosamente', 'Confirmación',
    MB_ICONINFORMATION);
  end
  else
  begin
    ZQProveedor.SQL.Text:='UPDATE proveedores SET celular = :celular,de = :de,'+
    ' direccion = :direccion,email = :email, empresa = :empresa, representante'+
    ' = :representante, rfc = :rfc, telefono = :telefono WHERE id_proveedor ='+
    ' :prov_id';

    ZQProveedor.Params.ParamByName('celular').AsString:=TxtCelular.Text;
    ZQProveedor.Params.ParamByName('de').AsString:=TxtDe.Text;
    ZQProveedor.Params.ParamByName('direccion').AsString:=TxtDir.Text;
    ZQProveedor.Params.ParamByName('email').AsString:=TxtEmail.Text;
    ZQProveedor.Params.ParamByName('empresa').AsString:=TxtEmpresa.Text;
    ZQProveedor.Params.ParamByName('representante').AsString:=TxtNombre.Text;
    ZQProveedor.Params.ParamByName('rfc').AsString:=TxtRFC.Text;
    ZQProveedor.Params.ParamByName('telefono').AsString:=TxtTelefono.Text;

    ZQProveedor.ExecSQL;
    Application.MessageBox('Proveedor actualizado exitosamente', 'Confirmación',
    MB_ICONINFORMATION);
  end;
  save:=true;
end;

procedure TFrmProveedor.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=save;
end;

procedure TFrmProveedor.FormShow(Sender: TObject);
begin
  save:=true;
  if edit then
  begin
    ZQProveedor.SQL.Text:='SELECT celular,de,direccion,email, empresa, '+
    'representante, rfc, telefono FROM proveedores WHERE id_proveedor = :prov_id';
    ZQProveedor.Params.ParamByName('prov_id').AsInteger:=prov_id;
    ZQProveedor.Open;
    if ZQProveedor.RecordCount > 0 then
    begin
      TxtIdent.Text:=prov_id.ToString;
      TxtEmpresa.Text:=ZQProveedor.FieldByName('empresa').AsString;
      TxtRFC.Text:=ZQProveedor.FieldByName('rfc').AsString;
      TxtEmail.Text:=ZQProveedor.FieldByName('email').AsString;
      TxtNombre.Text:=ZQProveedor.FieldByName('representante').AsString;
      TxtTelefono.Text:=ZQProveedor.FieldByName('telefono').AsString;
      TxtCelular.Text:=ZQProveedor.FieldByName('celular').AsString;
      TxtDe.Text:=ZQProveedor.FieldByName('de').AsString;
      TxtDir.Lines.Add(ZQProveedor.FieldByName('direccion').AsString);
    end;
  end;
end;

end.

