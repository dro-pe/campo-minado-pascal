program campo_minado_pascal;
const MIN = 0; MAX = 101; BORDA = -1; MINA = 9;
type status = record
    conteudo: longint;
    aberta  : boolean;
end;
type matriz_tabuleiro = array[MIN..MAX,MIN..MAX] of status;
type campo_minado = record
    tabuleiro     : matriz_tabuleiro;
    numero_linhas : longint;
    numero_colunas: longint;
    falta_abrir   : longint;
end;

procedure inicia_campo(var c: campo_minado);
var i, j, num_minas, randi, randj, num_lin, num_col: longint;
    frac_minas                                     : real;
begin
    writeln('Digite dois inteiros de 1 a 50 (numero de linhas e colunas do campo minado):');
    read(num_lin, num_col);
        while((num_lin < 1) OR (num_col < 1) OR (num_lin > 50) OR (num_col > 50)) do
        begin
            writeln('Valores invalidos. Por favor, digite dois inteiros de 1 a 50:');
            read(num_lin, num_col);
        end;

    c.numero_linhas := num_lin;
    c.numero_colunas := num_col;

    frac_minas := 0.2;
    
    num_minas := round(frac_minas*num_lin*num_col);
    c.falta_abrir := c.numero_linhas*c.numero_colunas - num_minas;

    for i := 0 to num_lin+1 do
        for j := 0 to num_col+1 do
        begin
            c.tabuleiro[i,j].conteudo := BORDA;
            c.tabuleiro[i,j].aberta := false;
        end;

    for i := 1 to num_lin do
        for j := 1 to num_col do
            c.tabuleiro[i,j].conteudo := 0;

    for i := 1 to num_minas do
    begin
        repeat
            randi := round(random(num_lin-1)) + 1;  (* os numeros aleatorios gerados devem ser 1 <= n <= tamanho da linha ou coluna *)
            randj := round(random(num_col-1)) + 1;
        until(c.tabuleiro[randi,randj].conteudo <> MINA); (* o repeat evita que a mina seja colocada em uma casa onde ja havia uma mina (otimizar isso depois)*)
        c.tabuleiro[randi,randj].conteudo := MINA;
    end;
end;

procedure imprime_campo(var c: campo_minado);
var i, j: longint;
begin
    for i := 1 to c.numero_linhas do
    begin
        for j := 1 to c.numero_colunas do
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