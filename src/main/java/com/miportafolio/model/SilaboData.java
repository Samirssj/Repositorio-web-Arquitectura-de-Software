package com.miportafolio.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Modelo con los datos oficiales del Sílabo de Arquitectura de Software
 * (Código: 332181)
 * Universidad Peruana Los Andes (UPLA) - Facultad de Ingeniería
 * 4 Unidades temáticas, 4 semanas por unidad (16 semanas en total).
 */
public class SilaboData {

    public static class SemanaInfo {
        private final int numero;
        private final int unidad;
        private final String titulo;
        private final String desempeno;
        private final String avance;

        public SemanaInfo(int numero, int unidad, String titulo, String desempeno, String avance) {
            this.numero = numero;
            this.unidad = unidad;
            this.titulo = titulo;
            this.desempeno = desempeno;
            this.avance = avance;
        }

        public int getNumero() {
            return numero;
        }

        public int getUnidad() {
            return unidad;
        }

        public String getTitulo() {
            return titulo;
        }

        public String getDesempeno() {
            return desempeno;
        }

        public String getAvance() {
            return avance;
        }
    }

    public static class UnidadInfo {
        private final int numero;
        private final String numeroRomano;
        private final String titulo;
        private final String capacidad;
        private final List<SemanaInfo> semanas;

        public UnidadInfo(int numero, String numeroRomano, String titulo, String capacidad) {
            this.numero = numero;
            this.numeroRomano = numeroRomano;
            this.titulo = titulo;
            this.capacidad = capacidad;
            this.semanas = new ArrayList<>();
        }

        public void agregarSemana(SemanaInfo semana) {
            this.semanas.add(semana);
        }

        public int getNumero() {
            return numero;
        }

        public String getNumeroRomano() {
            return numeroRomano;
        }

        public String getTitulo() {
            return titulo;
        }

        public String getCapacidad() {
            return capacidad;
        }

        public List<SemanaInfo> getSemanas() {
            return Collections.unmodifiableList(semanas);
        }
    }

    private static final List<UnidadInfo> UNIDADES = new ArrayList<>();
    private static final List<SemanaInfo> SEMANAS = new ArrayList<>();

    static {
        // =========================================================================
        // UNIDAD I: Fundamentos de la Arquitectura de Software y Estándares
        // Internacionales
        // =========================================================================
        UnidadInfo u1 = new UnidadInfo(
                1,
                "I",
                "Fundamentos de la Arquitectura de Software y Estándares Internacionales",
                "Explica los fundamentos de la arquitectura de software, utilizando los estándares internacionales, para la producción del software.");
        u1.agregarSemana(new SemanaInfo(
                1, 1,
                "Introducción a la Arquitectura de Software",
                "Identifica los conceptos, objetivos, importancia y elementos fundamentales de la arquitectura de software, analizando casos de estudio reales para reconocer su impacto en la calidad y sostenibilidad de un proyecto de software, como parte de la definición inicial de un proyecto integrador.",
                "6.25%"));
        u1.agregarSemana(new SemanaInfo(
                2, 1,
                "Principios, Atributos de Calidad y Estándares Internacionales",
                "Analiza los principios arquitectónicos, atributos de calidad y estándares internacionales aplicables al desarrollo de software, evaluando su contribución al cumplimiento de los requisitos funcionales y no funcionales del proyecto planteado.",
                "12.50%"));
        u1.agregarSemana(new SemanaInfo(
                3, 1,
                "Estilos y Patrones Arquitectónicos",
                "Compara estilos y patrones arquitectónicos de software mediante el análisis de escenarios de aplicación, seleccionando la alternativa más adecuada para la solución del proyecto desarrollado bajo la metodología ABP.",
                "18.75%"));
        u1.agregarSemana(new SemanaInfo(
                4, 1,
                "Documentación y Representación Arquitectónica",
                "Elabora la documentación preliminar de la arquitectura de software utilizando modelos, diagramas y buenas prácticas reconocidas internacionalmente, justificando las decisiones arquitectónicas adoptadas para el proyecto integrador.",
                "25.00%"));

        // =========================================================================
        // UNIDAD II: Modelado de la Arquitectura de Software mediante Programación
        // Orientada a Objetos
        // =========================================================================
        UnidadInfo u2 = new UnidadInfo(
                2,
                "II",
                "Modelado de la Arquitectura de Software mediante Programación Orientada a Objetos",
                "Crea la arquitectura del software, mediante la POO, para elaborar el modelo de la arquitectura del software.");
        u2.agregarSemana(new SemanaInfo(
                5, 2,
                "Principios de POO aplicados a la Arquitectura de Software",
                "Analiza los principios fundamentales de la Programación Orientada a Objetos (abstracción, encapsulamiento, herencia y polimorfismo), identificando su aplicación en la construcción de modelos arquitectónicos para el proyecto de software desarrollado mediante ABP.",
                "31.25%"));
        u2.agregarSemana(new SemanaInfo(
                6, 2,
                "Modelado Arquitectónico con UML",
                "Diseña diagramas UML (casos de uso, clases y paquetes) que representen la estructura lógica del proyecto de software, aplicando principios de modelado orientado a objetos y buenas prácticas de arquitectura.",
                "37.50%"));
        u2.agregarSemana(new SemanaInfo(
                7, 2,
                "Diseño de Componentes y Capas de la Arquitectura",
                "Construye el modelo arquitectónico del proyecto mediante la definición de componentes, capas, responsabilidades y relaciones entre objetos, garantizando la cohesión y el bajo acoplamiento de la solución propuesta.",
                "43.75%"));
        u2.agregarSemana(new SemanaInfo(
                8, 2,
                "Elaboración y Validación del Modelo Arquitectónico",
                "Integra los artefactos de modelado orientado a objetos para elaborar y validar la arquitectura del software del proyecto, sustentando técnicamente las decisiones de diseño adoptadas de acuerdo con los requisitos establecidos.",
                "50.00%"));

        // =========================================================================
        // UNIDAD III: Comunicación e Integración de Arquitecturas de Software
        // =========================================================================
        UnidadInfo u3 = new UnidadInfo(
                3,
                "III",
                "Comunicación e Integración de Arquitecturas de Software",
                "Conoce la comunicación de arquitecturas, utilizando los métodos y técnicas adecuadas, para definir los modos de transmisión de datos entre las mismas.");
        u3.agregarSemana(new SemanaInfo(
                9, 3,
                "Fundamentos de la Comunicación entre Arquitecturas",
                "Analiza los mecanismos de comunicación entre componentes y arquitecturas de software, identificando protocolos, modelos de interacción y flujos de información que permitan la integración efectiva de los módulos del proyecto desarrollado mediante ABP.",
                "56.25%"));
        u3.agregarSemana(new SemanaInfo(
                10, 3,
                "Métodos y Tecnologías para la Integración de Sistemas",
                "Selecciona métodos, tecnologías y estándares de comunicación para la integración de aplicaciones, evaluando alternativas como servicios web, APIs y mensajería, de acuerdo con los requerimientos funcionales y no funcionales del proyecto.",
                "62.50%"));
        u3.agregarSemana(new SemanaInfo(
                11, 3,
                "Diseño de Interfaces y Transmisión de Datos",
                "Diseña interfaces de comunicación y mecanismos de intercambio de datos entre componentes de software, aplicando técnicas de interoperabilidad y modelado de servicios para garantizar la correcta transmisión de información en el proyecto.",
                "68.75%"));
        u3.agregarSemana(new SemanaInfo(
                12, 3,
                "Implementación y Validación de la Comunicación Arquitectónica",
                "Implementa y valida los mecanismos de comunicación definidos para la arquitectura del proyecto, verificando la integridad, disponibilidad y eficiencia de la transmisión de datos mediante pruebas de integración.",
                "75.00%"));

        // =========================================================================
        // UNIDAD IV: Frameworks y Estándares para la Implementación de Arquitecturas de
        // Software
        // =========================================================================
        UnidadInfo u4 = new UnidadInfo(
                4,
                "IV",
                "Frameworks y Estándares para la Implementación de Arquitecturas de Software",
                "Utiliza los frameworks de arquitectura de software, utilizando normas internacionales, para obtener la arquitectura adecuada del software.");
        u4.agregarSemana(new SemanaInfo(
                13, 4,
                "Fundamentos de Frameworks de Arquitectura de Software",
                "Analiza las características, ventajas y ámbitos de aplicación de los principales frameworks de arquitectura de software, identificando su contribución al desarrollo de soluciones escalables, mantenibles y alineadas con los requisitos del proyecto desarrollado mediante ABP.",
                "81.25%"));
        u4.agregarSemana(new SemanaInfo(
                14, 4,
                "Normas y Buenas Prácticas en Arquitectura de Software",
                "Aplica normas internacionales, estándares y buenas prácticas de arquitectura de software para seleccionar el framework más adecuado, considerando criterios de calidad, interoperabilidad, seguridad y rendimiento del proyecto.",
                "87.50%"));
        u4.agregarSemana(new SemanaInfo(
                15, 4,
                "Implementación de la Arquitectura utilizando Frameworks",
                "Implementa componentes arquitectónicos del proyecto mediante un framework de software apropiado, integrando patrones de diseño, mecanismos de comunicación y principios de arquitectura previamente definidos.",
                "93.75%"));
        u4.agregarSemana(new SemanaInfo(
                16, 4,
                "Evaluación y Optimización de la Arquitectura de Software",
                "Evalúa la arquitectura implementada mediante pruebas y métricas de calidad, proponiendo mejoras y optimizaciones que garanticen el cumplimiento de los requisitos funcionales y no funcionales del proyecto.",
                "100.00%"));

        UNIDADES.add(u1);
        UNIDADES.add(u2);
        UNIDADES.add(u3);
        UNIDADES.add(u4);

        for (UnidadInfo u : UNIDADES) {
            SEMANAS.addAll(u.getSemanas());
        }
    }

    public static List<UnidadInfo> getUnidades() {
        return Collections.unmodifiableList(UNIDADES);
    }

    public static List<SemanaInfo> getSemanas() {
        return Collections.unmodifiableList(SEMANAS);
    }

    public static SemanaInfo getSemana(int numero) {
        if (numero < 1 || numero > SEMANAS.size()) {
            return SEMANAS.get(0);
        }
        return SEMANAS.get(numero - 1);
    }

    public static UnidadInfo getUnidad(int numeroUnidad) {
        if (numeroUnidad < 1 || numeroUnidad > UNIDADES.size()) {
            return UNIDADES.get(0);
        }
        return UNIDADES.get(numeroUnidad - 1);
    }

    public static UnidadInfo getUnidadDeSemana(int numeroSemana) {
        SemanaInfo sem = getSemana(numeroSemana);
        return getUnidad(sem.getUnidad());
    }
}
