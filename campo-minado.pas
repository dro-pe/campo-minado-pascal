program campo_minado_pascal;
const MIN = 1; MAX = 50; BORDA = -1; NADA = 0; MINA = 9;
type casa = record
    conteudo: integer;
    aberta  : boolean;
end;
type matriz_tabuleiro = array[MIN-1..MAX+1,MIN-1..MAX+1] of casa;
type campo_minado = record
    tabuleiro  : matriz_tabuleiro;
    num_lin    : integer;
    num_col    : integer;
    falta_abrir: longint;
    ganhou     : boolean;
    perdeu     : boolean;
end;

procedure zera_campo(var c: campo_minado);
var i, j: integer;
begin
    for i := 0 to c.num_lin+1 do
        for j := 0 to c.num_col+1 do
        begin
            c.tabuleiro[i,j].conteudo := BORDA;
            c.tabuleiro[i,j].aberta := false;
        end;

    for i := 1 to c.num_lin do
        for j := 1 to c.num_col do
            c.tabuleiro[i,j].conteudo := NADA;
end;

procedure distribui_minas(var c    : campo_minado;
                          num_minas: integer);
var cont, randi, randj: integer;
begin
    for cont := 1 to num_minas do
    begin
        repeat
            randi := round(random(c.num_lin-1)) + 1;       (* os numeros aleatorios gerados devem ser 1 <= n <= numero de linhas ou de colunas *)
            randj := round(random(c.num_col-1)) + 1;
        until(c.tabuleiro[randi,randj].conteudo <> MINA);  (* o repeat evita que a mina seja colocada em uma casa onde ja havia uma mina (otimizar isso depois)*)
        c.tabuleiro[randi,randj].conteudo := MINA;
    end;
end;

function conta_minas(var tab : matriz_tabuleiro;
                     lin, col: integer): integer;
var i, j: integer;
begin
    conta_minas := 0;
    for i := -1 to 1 do
        for j := -1 to 1 do
            if tab[lin + i,col + j].conteudo = MINA then
                conta_minas := conta_minas + 1;
end;

procedure inicia_campo(var c: campo_minado);
var i, j, num_minas: integer;
    frac_minas     : real;
begin
    writeln('Digite dois inteiros de ',MIN,' a ',MAX,' (numero de linhas e colunas do campo minado):');
    read(c.num_lin, c.num_col);
    while((c.num_lin < MIN) OR (c.num_col < MIN) OR (c.num_lin > MAX) OR (c.num_col > MAX)) do
    begin
        writeln('Valores invalidos. Por favor, digite dois inteiros de ',MIN,' a ',MAX,':');
        read(c.num_lin, c.num_col);
    end;

    frac_minas := 0.15;
    num_minas := round(frac_minas*c.num_lin*c.num_col);
    c.falta_abrir := c.num_lin*c.num_col - num_minas;

    zera_campo(c);
    distribui_minas(c, num_minas);

    for i := 1 to c.num_lin do
        for j := 1 to c.num_col do
            if c.tabuleiro[i,j].conteudo <> MINA then
                c.tabuleiro[i,j].conteudo := conta_minas(c.tabuleiro, i, j);

end;

procedure imprime_campo(var c: campo_minado);
var i, j: longint;
begin
    for i := 1 to c.num_lin do
    begin
        for j := 1 to c.num_col do
        begin
            if not(c.tabuleiro[i,j].aberta) then
                write('* ')
            else
                if c.tabuleiro[i,j].conteudo = NADA then
                    write('  ')
                else if c.tabuleiro[i,j].conteudo = MINA then
                    write('@ ')
                else
                    write(c.tabuleiro[i,j].conteudo,' ');
        end;
        writeln();
    end;
end;

procedure le_jogada(x, y: integer;
                    c   : campo_minado);
begin
    writeln('Digite as coordenadas da casa que voce quer abrir (numero da linha e depois numero da coluna):');
    read(x, y);
    while((x < 1) OR (y < 1) OR (x > c.num_lin) OR (y > c.num_col) OR c.tabuleiro[x,y].aberta) do
    begin
        if (c.tabuleiro[x,y].aberta) then
        begin
            writeln('Essa casa ja foi aberta, digite outra coordenada:');
            read(x, y);
        end
        else
        begin
            writeln('Por favor, digite coordenadas validas:');
            read(x, y);
        end;
    end;
end;

procedure executa_jogada(x, y: integer;
                         c   : campo_minado);

begin

end;

var c   : campo_minado;
    x, y: integer;
begin
    randomize;
    inicia_campo(c);
    imprime_campo(c);
    c.ganhou := false;
    c.perdeu := false;

    while not(c.ganhou OR c.perdeu) do
    begin
        le_jogada(x, y, c);
    //     executa_jogada(x, y, c);
        imprime_campo(c);
    end;

    if c.ganhou then
        writeln('Parabens, voce ganhou!')
    else
        writeln('MINA! Fim de jogo.');
end.