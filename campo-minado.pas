program campo_minado_pascal;
const MIN = 0; MAX = 101;
type campo_minado = array[MIN..MAX,MIN..MAX] of record
                                                    valor : integer;
                                                    aberta: boolean;
                                                end;

procedure inicia_campo(var c: campo_minado);
var i, j: integer;
begin
    for i := 0 to MAX do
        for j := 0 to MAX do
end;

var c   : campo_minado;
    x, y: integer;
begin
    randomize;

    inicia_campo(c);
    imprime_campo(c);
    writeln('Digite as coordenadas da casa que voce quer abrir (linha e coluna):');

    while not(ganhou(c) or perdeu(c)) do
    begin
        le_jogada(x, y, c);
        executa_jogada(x, y, c);
        imprime_campo(c);
    end;

    if ganhou(c) then
        writeln('Parabens, voce ganhou!')
    else
        writeln('BOMBA! Fim de jogo.');
end.