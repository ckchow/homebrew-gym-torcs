class Plib < Formula
  desc "Steve's portable game library"
  homepage "https://plib.sourceforge.io/index.html"
  url "http://plib.sourceforge.net/dist/plib-1.8.5.tar.gz"
  sha256 "485b22bf6fdc0da067e34ead5e26f002b76326f6371e2ae006415dea6a380a32"
  license "LGPL-2.0-only"

  patch :p1, :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sl",
                          "--disable-pw",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <plib/sg.h>
      #include <plib/fnt.h>
      #include <plib/js.h>
      #include <plib/net.h>
      #include <plib/psl.h>
      #include <plib/puAux.h>
      #include <plib/ul.h>
      int main() {
        sgVec3 Euler;
        sgSetVec3( Euler, 1, 1, 1 ) ;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}",
    "-lplibsg", "-lplibfnt", "-lplibjs", "-lplibnet", "-lplibpsl", "-lplibpuAux",
    "-lplibul",
    "-o", "test"
    system "./test"
  end
end

# NOTE: this patch comes from https://trac.macports.org/browser/trunk/dports/devel/plib/files
# via https://gist.github.com/mkroehnert/effb45389e14fc28c286
__END__
diff --git a/src/pui/puGLUT.h b/src/pui/puGLUT.h
index bd564a0..980035f 100644
--- a/src/pui/puGLUT.h
+++ b/src/pui/puGLUT.h
@@ -32,6 +32,7 @@

 #ifdef UL_MAC_OSX
 # include <GLUT/glut.h>
+# define APIENTRY
 #else
 # ifdef FREEGLUT_IS_PRESENT /* for FreeGLUT like PLIB 1.6.1*/
 #  include <GL/freeglut.h>
 diff --git a/src/ssg/ssgLoadFLT.cxx b/src/ssg/ssgLoadFLT.cxx
index 6990e25..6f9d4d2 100644
--- a/src/ssg/ssgLoadFLT.cxx
+++ b/src/ssg/ssgLoadFLT.cxx
@@ -142,7 +142,7 @@

 typedef unsigned char ubyte;

-#ifdef UL_WIN32
+#if defined(UL_WIN32) || defined(__APPLE__)
 typedef unsigned short ushort;
 typedef unsigned int uint;
 #endif