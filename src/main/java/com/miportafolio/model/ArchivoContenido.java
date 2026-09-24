package com.miportafolio.model;

public class ArchivoContenido {
    private Long archivoId;
    private byte[] datos;
    private String mimeType;
    private long tamanio;

    public ArchivoContenido() {}

    public ArchivoContenido(Long archivoId, byte[] datos, String mimeType, long tamanio) {
        this.archivoId = archivoId;
        this.datos = datos;
        this.mimeType = mimeType;
        this.tamanio = tamanio;
    }

    public Long getArchivoId() {
        return archivoId;
    }

    public void setArchivoId(Long archivoId) {
        this.archivoId = archivoId;
    }

    public byte[] getDatos() {
        return datos;
    }

    public void setDatos(byte[] datos) {
        this.datos = datos;
    }

    public String getMimeType() {
        return mimeType;
    }

    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }

    public long getTamanio() {
        return tamanio;
    }

    public void setTamanio(long tamanio) {
        this.tamanio = tamanio;
    }
}
