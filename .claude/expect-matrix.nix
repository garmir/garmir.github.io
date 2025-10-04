# Pure Nix Expect Configuration Matrix Generator
# Generates 255 test configurations for Claude Code interaction discovery
# Usage: nix-instantiate --eval --strict --json expect-matrix.nix

let
  # Test dimensions
  flags = [
    "--print"
    "--continue"
    "--dangerously-skip-permissions"
    ""
  ];

  prompts = [
    "hello"
    "test"
    "analyze compliance"
    ""
  ];

  apiStates = [ "with-key" "no-key" ];

  patterns = [ "basic" "comprehensive" "catch-all" ];

  timeouts = [ 30 60 120 ];

  # Generate cartesian product
  cartesianProduct = lists:
    if lists == [] then [[]]
    else
      let
        head = builtins.head lists;
        tail = builtins.tail lists;
        rest = cartesianProduct tail;
      in
        builtins.concatMap (x: map (xs: [x] ++ xs) rest) head;

  # All combinations
  allCombinations = cartesianProduct [ flags prompts apiStates patterns timeouts ];

  # Take first 255
  totalLength = builtins.length allCombinations;
  limitedLength = if totalLength > 255 then 255 else totalLength;
  limited = builtins.genList (i: builtins.elemAt allCombinations i) limitedLength;

  # Convert to configuration objects
  toConfig = i: combo:
    {
      id = i;
      flag = builtins.elemAt combo 0;
      prompt = builtins.elemAt combo 1;
      apiState = builtins.elemAt combo 2;
      pattern = builtins.elemAt combo 3;
      timeout = builtins.elemAt combo 4;
    };

  configurations = builtins.genList (i: toConfig i (builtins.elemAt limited i))
    (builtins.length limited);

in
  configurations
