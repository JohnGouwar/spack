from spack.package import *

class Manyvariants(Package):
    homepage = "https://www.test.com"
    has_code = False
    version("1.0.0")
    version("1.0.1")
    version("2.0.0")
    version("2.0.1")

    variant("a", default=True)
    variant("b", default=False)
    variant("c", values=("v1", "v2", "v3"), multi=False, default="v1")
    variant("d", values=("v1", "v2", "v3"), multi=False, default="v1")

    can_splice("manyvariants@1.0.0", when="@1.0.1", match_variants="*")
    can_splice("manyvariants@2.0.0+a~b", when="@2.0.1~a+b", match_variants=["c", "d"])
    can_splice("manyvariants@2.0.0 c=v1 d=v1", when="@2.0.1+a+b")
    
    def install(self, spec, prefix):
        touch(prefix.bar)
    
    
