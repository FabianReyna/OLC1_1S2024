/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package analisis;

/**
 *
 * @author fabian
 */
public class Errores {

    public String tipo;
    public String desc;
    public int linea;
    public int columna;

    public Errores(String tipo, String desc, int linea, int columna) {
        this.tipo = tipo;
        this.desc = desc;
        this.linea = linea;
        this.columna = columna;
    }

    @Override
    public String toString() {
        return "Errores{" + "tipo=" + tipo + ", desc=" + desc + ", linea=" + linea + ", columna=" + columna + '}';
    }
    
    
    
    

}
