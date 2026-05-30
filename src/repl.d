import std.stdio : writef, writeln, readln;

void main()
{
  writeln("Delisp Repl (Press Ctrl+C to quit).");
  int line = 1;
  while (true) {
    writef("%d %% ", line++);
    readln();
  }
}

