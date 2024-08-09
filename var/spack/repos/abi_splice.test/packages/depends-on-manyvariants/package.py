from spack.package import *

class DependsOnManyvariants(Package):
    homepage = "https://www.test.com"
    has_code = False
    
    version("1.0")
    version("2.0")
    depends_on("manyvariants@1.0", when="@1.0")
    depends_on("manyvariants@2.0", when="@2.0")
    
    def install(self, spec, prefix):
        touch(prefix.bar)
