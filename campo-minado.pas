program campo_minado_pascal;
const MIN = 0; MAX = 51; BORDA = -1; MINA = 9;
type status = record
    conteudo: integer;
    aberta  : boolean;
end;
type matriz_tabuleiro = array[MIN..MAX,MIN..MAX] of status;
type campo_minado = record
    tabuleiro  : matriz_tabuleiro;
    num_lin    : integer;
    num_col    : integer;
    falta_abrir: longint;
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
            c.tabuleiro[i,j].conteudo := 0;
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
    writeln('Digite dois inteiros de 1 a 50 (numero de linhas e colunas do campo minado):');
    read(c.num_lin, c.num_col);
    while((c.num_lin < 1) OR (c.num_col < 1) OR (c.num_lin > 50) OR (c.num_col > 50)) do
    begin
        writeln('Valores invalidos. Por favor, digite dois inteiros de 1 a 50:');
        read(c.num_lin, c.num_col);
    end;

    frac_minas := 0.2;
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
            // if not(c.tabuleiro[i,j].aberta) then
            //     write('* ')
            // else
                if c.tabuleiro[i,j].conteudo = 0 then
                    write('  ')
                else if c.tabuleiro[i,j].conteudo = MINA then
                    write('@ ')
                else
                    write(c.tabuleiro[i,j].conteudo,' ');
        end;
        writeln();
    end;
end;

var c   : campo_minado;
    // x, y: longint;
begin
    randomize;

    inicia_campo(c);
    imprime_campo(c);

    // while not(ganhou(c) or perdeu(c)) do
    // begin
    //     le_jogada(x, y, c);
    //     executa_jogada(x, y, c);
    //     imprime_campo(c);
    // end;

    // if ganhou(c) then
    //     writeln('Parabens, voce ganhou!')
    // else
    //     writeln('MINA! Fim de jogo.');
end.