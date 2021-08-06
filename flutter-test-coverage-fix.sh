#!/bin/sh

# See https://github.com/flutter/flutter/issues/27997#issuecomment-587536884
# Remove once issue is fixed
package=todos
file=test/coverage_fixer_test.dart

echo "// Helper file to make coverage work for all dart files\n" > $file
echo "// ignore_for_file: unused_import" >> $file
find lib -not -name '*.g.dart' -and -name '*.dart' | cut -c4- | awk -v package=$package '{printf "import '\''package:%s%s'\'';\n", package, $1}' >> $file
echo "void main(){}" >> $file