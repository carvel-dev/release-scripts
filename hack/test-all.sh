set -e -x -u

./test/generate_homebrew_formula_test.sh
./test/generate_install_sh_test.sh

echo ALL SUCCESS
