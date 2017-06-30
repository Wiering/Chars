program Chars;

{$APPTYPE CONSOLE}

  uses
    SysUtils;

  const
    BUF_SIZE = $8000;

  var
    Filename: string;
    FI: file of Char;
    Count: array[0..255] of Integer;
    Buffer: array[0..BUF_SIZE - 1] of Char;
    NumRead: Integer;

  const
    W = 8;
    H = 32;

  var
    i, j, k, n: Integer;
    ch: Char;
    max: Integer;
    wd: Integer;
    s: string;

begin
  if (ParamCount < 1) then
  begin
    WriteLn ('syntax: chars filename');
    Halt (0);
  end;

  for i := 0 to 255 do
    Count[i] := 0;

  Filename := ParamStr (1);
  if (not FileExists (Filename)) then
  begin
    WriteLn ('file not found: ' + Filename);
    Halt (1);
  end;
  AssignFile (FI, Filename);
  Reset (FI);

  NumRead := BUF_SIZE;
  while NumRead = BUF_SIZE do
  begin
    BlockRead (FI, Buffer, BUF_SIZE, NumRead);
    for i := 0 to NumRead - 1 do
      Inc (Count[ord (Buffer[i])]);
  end;
  CloseFile (FI);

  max := 0;
  for i := 0 to 255 do
    if (Count[i] > max) then
      max := Count[i];
  wd := Length (IntToStr (max));

  for j := 0 to H - 1 do
  begin
    for i := 0 to W - 1 do
    begin
      n := j + i * H;
      Ch := Chr (n);
      if (Ch in [#8, #9, #10, #13, #7]) then
        Ch := ' ';
      if (n <= 255) then
      begin
        s := ' ' + IntToStr (Count[n]);
        while Length (s) < wd + 1 do
          s := '.' + s;
        Write (n: 3, ' ', Ch, ' .', s, '   ');
      end;
    end;
    WriteLn;
  end;


end.