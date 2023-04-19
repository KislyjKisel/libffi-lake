import Lake
open Lake DSL

package libffi

def libffiVersion := "3.4.4"

def tryRunProcess_ {m} [Monad m] [MonadError m] [MonadLiftT IO m] (sa : IO.Process.SpawnArgs) : m Unit := do
  let output ← IO.Process.output sa
  if output.exitCode ≠ 0 then
    error s!"'{sa.cmd}' returned {output.exitCode}: {output.stderr}"
  else
    pure ()

@[default_target]
extern_lib libffi (pkg : Package) := do
  match get_config? src with
    | none | some "release" =>
      tryRunProcess_ {
        cmd := if System.Platform.isWindows then s!"{pkg.dir}/build.bat" else s!"{pkg.dir}/build.sh"
        cwd := pkg.dir
      }
    | some other => error s!"`libffi` unknown `src` '{other}'"
  inputFile $ pkg.dir / "lib" / (nameToStaticLib "ffi")

script clean := do
  if System.Platform.isWindows
    then do
      tryRunProcess_ {
        cmd := "rd",
        args := #["/s", "/q", s!"{__dir__}\\include"]
      }
      tryRunProcess_ {
        cmd := "rd",
        args := #["/s", "/q", s!"{__dir__}\\lib"]
      }
    else
      tryRunProcess_ {
        cmd := "rm",
        args := #["-rf", s!"{__dir__}/include", s!"{__dir__}/lib"]
      }
  pure 0
