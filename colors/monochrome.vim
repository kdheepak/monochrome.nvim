lua << EOF
package.loaded['monochrome'] = nil
package.loaded['monochrome.util'] = nil
package.loaded['monochrome.colors'] = nil
package.loaded['monochrome.theme'] = nil
require('monochrome').colorscheme()
EOF
