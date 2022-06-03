Program SPDVJRGG;
uses crt, printer, dos, strings;
const
   max = 100;
   col = 24;
   arqpro = 'prod.txt';
   arqmsg = 'msg.txt';
type
   produtos = record
      cod: string[13];
      nom: string[27];
      val: real;
   end;
var
   prod: array [1..max] of produtos;
   n: integer;
   saida: char;
   razaos: string[48];
   ende: string[48];
   cidade: string[48];
   msg: string[48];

(* n qnt de itens válidos no vetor *)
(* PROD[1|2|3|4|..|N|N+1|N+2|N+..|MAX]*)
(* n qnt de itens válidos no vetor *)


(* Inicio do Programa *)

function centra(texto: string): string;
(*Está função centraliza o texto na TELA// 40 é o total de colunas div 2*)
var
   espaco: string;
   x: word;
begin
     espaco := '';
     for x := 1 to (38 - ((length(texto)) div 2)) do
         espaco := espaco + ' ';
     centra := espaco + texto;
end;

function caixalta(text: string): string;
(*Esta função passa o texto para MAIUSCULO*)
var c: char;
    txt: string;
    x: word;
begin
   txt:= '';
   for x := 1 to length(text) do
   begin
      c := text[x];
      c := upcase(c);
      txt := txt + c;
   end;
   caixalta := txt;
end;

function centraprn(texto: string): string;
(*Esta função coloca o texto centralizado para a impressora
é necessário passar a qnt de colunas*)
var
   espaco: string;
   x: word;
begin
   espaco := '';
   for x := 1 to (col - ((length(texto)) div 2)) do
      espaco := espaco + ' ';
   centraprn := espaco + texto;
end;

function fontAlt2(texto: string): string;
(*IM433 Altura dupla*)
const
(*IM433 Altura dupla*)
   abre = chr(27)+chr(100)+chr(01);
   fecha = chr(27)+chr(100)+chr(00);
begin
   fontAlt2 := abre + texto + fecha;
end;

Procedure abregaveta;
(*Abertura de gaveta em LPT1 na IM433*)
begin
   write(lst,chr(27)+chr(38)+chr(48)+chr(18)+chr(72));
end;

Function busca(pesq: string): integer;
(* essa é a funçao de busca, eh passado o nome a ser procurado
se ele for achado, e voltado o numero de sua posição no vetor
se não, eh voltado -1 *)
var
   inicio, meio, fim: word;
   achou: boolean;
begin
   inicio := 1;
   fim := n;
   achou := false;
   pesq := caixalta(pesq);
   repeat
      meio := (inicio + fim) div 2;
      if pesq > prod[meio].cod then
         inicio := meio + 1
      else if pesq < prod[meio].cod then
         fim := meio - 1
      else if pesq = prod[meio].cod then
         achou := true;
   until ((inicio = meio) or (fim = meio)) or achou;
   if achou then
       busca := meio
   else busca := max+1;
end;

function horas:string;
var hora, minu, seg, cent: word;
    h, m, s: string[2];
begin
   GetTime(hora, minu, seg,cent);
   horas := IntToStr(hora)+ ':' + IntToStr(minu)+':'+ IntToStr(seg);
end;

Procedure titulo;
begin;
   clrscr;
   writeln;
   writeln(centra('JRGG Roberto Sistemas'));
   writeln(centra('copyright (c) 1982 - 2006'));
   writeln(centra('http://jrgg.ueuo.com   jrggroberto@gmail.com'));
   writeln('                                                                       ',n:8);
   writeln('--------------------------------------------------------------------------------');
end;

Procedure gravanodisk;
var arquivo: text;
    x: word;
Begin
   clrscr;
   assign(arquivo,arqpro);
   rewrite(arquivo);
   for x := 1 to n do
   begin
       writeln(arquivo,prod[x].cod);
       writeln(arquivo,prod[x].nom);
       writeln(arquivo,prod[x].val:8:2);
   end;
   close(arquivo);
   writeln('Gravado com sucesso');
end;

procedure ordena;
var i, j: word;
    auxCod: string[13];
    auxNom: string[27];
    auxVal: real;
begin
   for i := 1 to n do
     for j := i + 1 to n do
        if prod[i].cod > prod[j].cod then
        begin
           auxCod := prod[i].cod;
           auxNom := prod[i].nom;
           auxVal := prod[i].val;

           prod[i].cod := prod[j].cod;
           prod[i].nom := prod[j].nom;
           prod[i].val := prod[j].val;

           prod[j].cod := auxCod;
           prod[j].nom := auxNom;
           prod[j].val := auxVal;
        end;
end;

Procedure CadastProd;
var resp: char;
    codtemp:string[13];
begin
   repeat
      titulo;
      writeln(centra('C O N F I G U R A C A O  -  PRODUTOS - Cadastro'));
      writeln;
      write('Cod: ');     readln(codtemp);
      codtemp := caixalta(codtemp);
      if ((busca(codtemp)) >= (max+ 1)) then
      begin
         with prod[n + 1] do
         begin
            cod := codtemp;
            write('Nome: ');  readln(nom);   nom := caixalta(nom);
            write('R$: ');    readln(val);
         end;
         n := n + 1;
         writeln;
         write('Cadastrar mais um?[S/N]');
         resp := upcase(readkey);
         case resp of
            'S': writeln('continuar');
            'N': writeln('bye!')
            else writeln(centra('Selecione de S a N!'));
         end;
      end else
      begin
         writeln('Produto já cadastrado!!!');
         write('Continuar?[S/N]');
         resp := upcase(readkey);
         case resp of
            'S': writeln('Cadastrar');
            'N': writeln('bye!')
            else writeln(centra('Selecione de S a N!'));
         end;
      end;
   until resp = 'N';
   ordena;
   gravanodisk;
end;

Procedure exclprod(var i: integer);
var codig: string[13];
    resp: char;
    x: integer;
begin
   writeln;
   writeln(centra('Excluir'));
   writeln('--------------------------------------------------------------------------------');
   write('Tem certeza?[S/N] ');
   repeat
      resp := upcase(readkey);
      case resp of
         'S': begin
                 for x := i to n do
                 begin
                    prod[x].cod := prod[x + 1].cod;
                    prod[x].nom := prod[x + 1].nom;
                    prod[x].val := prod[x + 1].val;
                 end;
                 n := n - 1;
              end;
         'N': writeln('Nenhum excluso;')
         else writeln('Digite S ou N!!!');
      end;
   until resp in ['S','N'];
   gravanodisk;
   writeln('Excluido!!!');
end;

Procedure editprod(var i: integer);
var codig: string[13];
begin
   writeln;
   writeln(centra('Editar'));
   writeln('--------------------------------------------------------------------------------');
   with prod[i] do
   begin
      codig := cod;
      write('Cod: ');   readln(cod);   cod := caixalta(cod);
      write('Nome: ');  readln(nom);   nom := caixalta(nom);
      write('R$: ');    readln(val);
   end;
   if codig = prod[i].cod then
      ordena;
   gravanodisk;
   writeln('Atualizado!!!');
end;

Procedure ExclEdtProd;
var resp: char;
    localizar: string;
    x: integer;
begin
   repeat
      titulo;
      writeln(centra('C O N F I G U R A C A O  -  PRODUTOS - Listar'));
      writeln;
      write('Digite o codigo: ');
      readln(localizar);
      x := busca(localizar);
      writeln;
      if ( x > max) then
         writeln('Código não encontrado!!!')
      else
      begin
         with prod[x] do
         begin
            writeln('Cod: ',cod);
            writeln('Nome: ',nom);
            writeln('R$: ',val:8:2);
         end;
         writeln;
         writeln(centra('1 - Editar            '));
         writeln(centra('2 - Excluir           '));
         writeln(centra('3 - Voltar            '));
         repeat
            write('Opcao: ');
            resp := upcase(readkey);
            case resp of
               '1': begin
                       editprod(x);
                       resp := '3';
                    end;
               '2': begin
                       exclprod(x);
                       resp := '3';
                    end;
               '3': writeln('bye!')
               else writeln(centra('Selecione de 1 a 3!'));
            end;
         until resp = '3';
      end;
      write('Outro?[S/N] ');
      resp := upcase(readkey);
      case resp of
         'S': writeln('.');
         'N': writeln('bye')
         else writeln('Digite S ou N');
      end;
   until resp = 'N';
end;

Procedure ListaProd;
var resp: char;
    x: integer;
begin
   repeat
      titulo;
      writeln(centra('C O N F I G U R A C A O  -  PRODUTOS - Listar'));
      writeln;
      writeln(centra('1 - Tela              '));
      writeln(centra('2 - Impressora        '));
      writeln(centra('3 - Voltar            '));
      writeln;
      write('Opcao: ');
      resp := readkey;
      case resp of
         '1':  begin
                  writeln;   writeln;
                  for x := 1 to n do
                  begin
                     with prod[x] do
                     begin
                        writeln('  Cod: ',cod:13,'  Nome: ',nom:27,'  R$: ',val:8:2);
                     end;
                  end;
                  writeln;   readkey;
               end;
         '2':  for x := 1 to n do
               begin
                  with prod[x] do
                  begin
                     writeln(lst,'Cod: ',cod:13,'  Nome: ',nom:27,'  R$: ',val:8:2);
                  end;
               end;
         '3': writeln('bye!')
         else writeln(centra('Selecione de 1 a 3!'));
      end;
   until resp = '3';
end;

Procedure MenuProdu;
var resp: char;
begin
   repeat
      titulo;
      writeln(centra('C O N F I G U R A C A O  -  PRODUTOS'));
      writeln;
      writeln(centra('1 - Listar            '));
      writeln(centra('2 - Cadastrar         '));
      writeln(centra('3 - Editar/Excluir    '));
      writeln(centra('4 - Voltar            '));
      writeln;
      write('Opcao: ');
      resp := readkey;
      case resp of
         '1': ListaProd;
         '2': CadastProd;
         '3': ExclEdtProd;
         '4': writeln('bye!')
         else writeln(centra('Selecione de 1 a 4!'));
      end;
   until resp = '4';
end;

Procedure EdtCupom;
var resp: char;
    arquivo: text;
    uf: string[2];
    bairro: string[18]; (*cidade[40]*)
    num: string[9];
begin
   repeat
      titulo;
      writeln(centra('C O N F I G U R A C A O  -  EITAR CUPOM'));
      writeln;
      writeln(centra(razaos));
      writeln(centra(ende));
      writeln(centra(cidade));
      writeln(centra('------------------------------------------------'));
      writeln;
      writeln(centra('------------------------------------------------'));
      writeln(centra(msg));
      writeln;
      write('Alterar?[S/N] ');
      resp := upcase(readkey);
      case resp of
         'S': begin
                 writeln;
                 write('Razao Social: ');    readln(razaos);
                 write('Endereco: ');        readln(ende);
                 write('Numero: ');          readln(num);
                 write('Cidade: ');          readln(cidade);
                 write('UF: ');              readln(uf);
                 write('Bairro: ');          readln(bairro);
                 write('Mensagem: ');        readln(msg);
                 ende := ende + ' ' + num;
                 cidade := cidade + ' ' + uf + ' ' + bairro;
                 (*grava em arquivo txto*)
                 assign(arquivo,arqmsg);
                 rewrite(arquivo);
                    writeln(arquivo,razaos);
                    writeln(arquivo,ende);
                    writeln(arquivo,cidade);
                    writeln(arquivo,msg);
                 close(arquivo);
                 (*fim de gravar no arquivo txt*)
                 writeln('Alterado com sucesso!!!');
              end;
         'N': writeln('bye');
         else writeln(centra('Digite S ou N!'));
      end;
   until resp = 'N';
end;

Procedure MenuConf;
var resp: char;
begin
   repeat
      titulo;
      writeln(centra('C O N F I G U R A C A O'));
      writeln;
      writeln(centra('1 - Cabecario         '));
      writeln(centra('2 - Produtos          '));
      writeln(centra('3 - Voltar            '));
      writeln;
      write('Opcao: ');
      resp := readkey;
      case resp of
         '1': EdtCupom;
         '2': MenuProdu;
         '3': writeln('bye!')
         else writeln(centra('Selecione de 1 a 3!'));
      end;
   until resp = '3';
end;

Procedure disponivel;
begin
   titulo;
   saida := 'N';
   writeln(centra('Caixa Disponivel'));
   writeln;
   writeln(centra('Continuar      '));
   writeln(centra('Sair press S   '));
   saida := upcase(readkey);
end;

Procedure fechamento(total: real);
var
   totall, pag: real;
   resp: char;
begin
   totall := total;
   saida := 'N';
   repeat
      titulo;
      writeln(centra('Forma de Pagamento'));
      writeln;
      writeln(centra('1 - Dinheiro       '));
      writeln(centra('2 - Cheque         '));
      writeln(centra('3 - Cartao         '));
      writeln(centra('4 - Fiado          '));
      writeln;

      write(centra('Total R$ '));     writeln(total:8:2);
      write(centra('Faltando R$ '));  writeln(Totall:8:2);
      write(centra('Opcao: '));
      resp := readkey;
      writeln;
      write('Pagar R$: ');
      readln(pag);
      case resp of
         '1': begin
                 if totall > pag then
                     totall := totall - pag
                 else
                     totall := pag - totall;
                 writeln(lst,'Dinheiro R$                             ',pag:8:2);
                 if pag > total then
                     writeln(lst,'Troco    R$                             ',pag-totall:8:2);
              end;
         '2': begin
                 pag := totall + 1 ;
                 writeln(lst,'Cheque   R$                             ',pag:8:2);
              end;
         '3': begin
                 pag := totall + 1 ;
                 writeln(lst,'Cartao   R$                             ',pag:8:2);
              end;
         '4': begin
                 pag := totall + 1 ;
                 writeln(lst,'Fiado    R$                             ',totall:8:2);
              end;
         else writeln(centra('Selecione de 1 a 4!'));
      end;
///
      write(centra('Total R$ '));     writeln(total:8:2);
      write(centra('Faltando R$ '));  writeln(Totall:8:2);
      write(centra('Opcao: ')); readkey;
///
   until (pag > totall);

   writeln(lst,'________________________________________________');
   writeln(lst,'                                        ',horas:8);
   writeln(lst,fontalt2(centraprn(msg)));
   writeln(lst);
   writeln(lst);
   writeln(lst);
   writeln(lst);
   writeln(lst);
   abregaveta;
   disponivel;
end;

Procedure finalizar(x: real);
begin
   writeln(lst);
   write(lst,'TOTAL R$                                ');
   write(lst,chr(27)+chr(100)+chr(01)); (*coloca em atura dubla*)
   write(lst,x:8:2);                    (*imprime o total*)
 //  write(lst, chr(27)+chr(100)+chr(00)+chr(13)); (*tira atura dubla*)
//   writeln(lst);
   write(lst,fontalt2(''));
   fechamento(x);
end;

Procedure vender;

var cod: string[13];    (*codigo do produto EAN13*)
    x: integer;          (*ITEM = indice no cupom *)
    qnt, y, z: word;
    valor, subtot, total: real; (* valores do cupom *)
begin
   writeln(lst,fontalt2(centraprn(razaos)));
   writeln(lst,centraprn(ende));
   writeln(lst,centraprn(cidade));
   writeln(lst);
   writeln(lst,'                                        ',horas:8);
   write(lst,chr(15),'ITEM       CODIGO                DESCRICAO QNTxUNIT     SUBTOTAL',chr(15));
(*                   '1234567890123456789012345678901234567890123456789012345678901234'
                     'XXX 1234567890123 123456789012345678901234 XXXXXXXX.XX  XXXXX.XX'
                     'xxx 1234567890123 123456789012345678901234 333x3333.33  12345678' *)
   write(lst,'----------------------------------------------------------------');
   total := 0;
   y := 1;
   repeat
      gotoxy(18,11);
      readln(cod);
      x := busca(cod);
      if (x >= (max+1)) then
      begin
         sound(2000);
         gotoxy(1,11);
         writeln('         Codigo:                         Prod: PRODUTO NAO CADASTRADO!!!       ');
         delay(50);
         nosound;
      end
      else
      begin
         qnt := 1;
         gotoxy(48,11);          write(prod[x].nom);
         valor := (prod[x].val);
         subtot := valor * qnt;
         gotoxy(48,18);          write(total:8:2);
         gotoxy(48,13);          write(valor:8:2);
         gotoxy(48,15);          write(subtot:8:2);
         gotoxy(18,13);          readln(qnt);
         subtot := valor * qnt;
         total := total + subtot;
         gotoxy(48,15);          write(subtot:8:2);
         gotoxy(48,18);          write(total:8:2);
         delay(200);
         gotoxy(1,11);
         writeln('         Codigo:                         Prod:                                 ');
         writeln;
         Writeln('         Qntdad:                      Val Unt:                                 ');
         writeln;
         Writeln('                                    Sub Total:                                 ');
         write(lst,chr(15),y:3,' ', cod:13,' ',prod[x].nom:24,' ',qnt:3,'x',valor:7:2,'  ',subtot:8:2, chr(18));
         y := y + 1;
      end;
   until cod = '';
   finalizar(total);
end;

Procedure telavenda;
begin
   repeat
      titulo;
      writeln(centra('MODO VENDAS'));
      Writeln;
      Writeln;
      writeln('         Codigo:                         Prod:                                 ');
      writeln;
      Writeln('         Qntdad:                      Val Unt:                                 ');
      writeln;
      Writeln('                                    Sub Total:                                 ');
      writeln;writeln;
      Writeln('                                        Total:                                 ');
      writeln;
      writeln;
      Write('                                                                   Fechar: Enter');
      vender;
   until saida = 'S';
end;

Procedure MenuP;
var resp: char;
begin
   repeat
      titulo;
      writeln(centra('M E N U'));
      writeln;
      writeln(centra('1 - Vendas            '));
      writeln(centra('2 - Configuracao      '));
      writeln(centra('3 - Sair              '));
      writeln;
      write(centra('Opcao: '));
      resp := readkey;
      case resp of
         '1': begin
                 telavenda;
              end;
         '2': Menuconf;
         '3': writeln('bye!')
         else writeln(centra('Selecione de 1 a 3!'));
      end;
   until resp = '3';
end;

Procedure GetMsgs;
var arquivo: text;
begin
   assign(arquivo,arqmsg);
   reset(arquivo);
      readln(arquivo,razaos);
      readln(arquivo,ende);
      readln(arquivo,cidade);
      readln(arquivo,msg);
   close(arquivo);
end;

Procedure InicioProd;
var arquivo: text;
begin
   assign(arquivo,arqpro);
   reset(arquivo);
   n := 0;  (* "n" é a qnt de itens validos no vetor de um total "max" *)
   repeat
      n := n + 1;
      readln(arquivo,prod[n].cod);
      readln(arquivo,prod[n].nom);
      readln(arquivo,prod[n].val);
   until (prod[n].cod = '') or (n >= max);
   n := n - 1;
   close(arquivo);
end;

Begin
   textbackground(3);
   textcolor(11);
   InicioProd;
   GetMsgs;
   MenuP;
end.