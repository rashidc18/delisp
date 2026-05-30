import std.stdio : writefln, writeln;
import std.process : spawnProcess, wait;
import std.path : stripExtension;
import std.array;

version(Windows)
{
  static immutable string PATH_SEP = "\\";
}
else
{
  static immutable string PATH_SEP = "/";
}

string DCOMPILER = "dmd";

string SRC_DIR = "src";
string REPL = "repl.d";
string INTERPRETER = "interpreter.d";

string[] INCLUDES_FILES = [];

void echo(string type, string message)
{
  writefln("[%s] %s", type, message);
}

int cmd(string type, string[] command)
{
  echo(type, command.join(" "));
  auto pid = spawnProcess(command);
  return wait(pid);
}

int build(string file, string[] include, string output)
{
  string[] command = [DCOMPILER, SRC_DIR ~ PATH_SEP ~ file];
  foreach(inc; include)
    command ~= SRC_DIR ~ PATH_SEP ~ inc;
  command ~= "-of=" ~ output;
  return cmd("BUILD", command);
}

void usage()
{
  writeln("Usage: rdmd build.d [option]");
  writeln("Options:");
  writeln("  -help          Display this message.");
  writeln("  -repl          Build only repl.");
  writeln("  -interpreter   Build only interpreter.");
}

int main(string[] args)
{
  if (args.length > 1) {
    string option = args[1];
    switch(option) {
      case "-help":
        usage();
        return 0;

      case "-repl":
        return build(REPL, INCLUDES_FILES, "repl");

      case "-interpreter":
        return build(INTERPRETER, INCLUDES_FILES, "interpreter");
     
      default:
        usage();
        return 1;
    }
  }

  string[] all = [REPL, INTERPRETER];
  foreach (file; all) {
    int r = build(file, INCLUDES_FILES, stripExtension(file));
    if (r != 0) return r;
  }

  return 0;
}

