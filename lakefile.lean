import Lake
open Lake DSL

package libffi

def libffiVersion := "3.4.4"

def tryRunProcess {m} [Monad m] [MonadError m] [MonadLiftT IO m] (sa : IO.Process.SpawnArgs) : m String := do
  let output ← IO.Process.output sa
  if output.exitCode ≠ 0 then
    error s!"'{sa.cmd}' returned {output.exitCode}: {output.stderr}"
  else
    return output.stdout

@[default_target]
extern_lib libffi (pkg : Package) := do
  match get_config? src with
    | none | some "release" =>
      tryRunProcess {
        cmd := "./build.sh"
        cwd := pkg.dir
      }
    | some other => error s!"`libffi` unknown `src` '{other}'"
  inputFile $ pkg.dir / "lib" / (nameToStaticLib "ffi")

script clean := do
  let outp ← IO.Process.output {
    cmd := "rm"
    args := #["-rf", s!"libffi-{libffiVersion}", "include", "lib"]
  }
  pure outp.exitCode
