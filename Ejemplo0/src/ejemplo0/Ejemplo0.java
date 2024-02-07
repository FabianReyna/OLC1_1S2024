package ejemplo0;

import analisis.parser;
import analisis.scanner;
import java.io.BufferedReader;
import java.io.StringReader;

/**
 *
 * @author fabian
 */
public class Ejemplo0 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            scanner s = new scanner(new BufferedReader(new StringReader("<Ejemplo>\n"
                    + "	System.print.Line{\"Hola mundo\"};\n"
                    + "	System.print.Line{Concatenar(\"cadena\",123)};\n"
                    + "</Ejemplo>")));
            parser p = new parser(s);
            var result =  p.parse();
            System.out.println("IMPRRESION DESDE RESULT");
            System.out.println(result.value);
            System.out.println("IMPRESION DESDE LINKEDLIST");
            var cadenas = p.cadenas;
            for (var c : cadenas) {
                System.err.println(c);
            }
            System.out.println("");
        } catch (Exception e) {
            System.out.println("Ocurrio un error, Ya no sale COMPI1 :'V");
        }
    }

}
