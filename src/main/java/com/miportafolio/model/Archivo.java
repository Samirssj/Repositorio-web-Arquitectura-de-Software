package com.miportafolio.model;

import java.time.LocalDateTime;

public class Archivo {
    private Long id;
    private String nombre;
    private String descripcion;
    private String tipo;
    private String url;
    private Long usuarioId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Archivo() {}

    public Archivo(String nombre, String descripcion, String tipo, String url, Long usuarioId) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.tipo = tipo;
        this.url = url;
        this.usuarioId = usuarioId;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Long getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Long usuarioId) {
        this.usuarioId = usuarioId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Archivo{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", tipo='" + tipo + '\'' +
                ", url='" + url + '\'' +
                '}';
    }
}
