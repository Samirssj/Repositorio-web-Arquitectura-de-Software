<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.miportafolio.model.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="com.miportafolio.model.Archivo" %>
<!DOCTYPE html>
<html lang="es" data-theme="light">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Gestión de Contenido | Academia</title><link rel="stylesheet" href="css/style.css"></head>
<body>
<%
Usuario usuario=(Usuario)session.getAttribute("usuario");
if(usuario==null){response.sendRedirect("login");return;}
List<Archivo> archivos=(List<Archivo>)request.getAttribute("archivos");
%>
<div class="dashboard-shell">
<aside class="sidebar">
<a class="brand" href="${pageContext.request.contextPath}/"><span class="brand-mark">A</span> ACADEMIA</a>
<div class="sidebar-label">Navegación</div>
<a class="sidebar-link" href="${pageContext.request.contextPath}/"><span class="sidebar-icon">⌂</span>Inicio</a>
<a class="sidebar-link" href="unidades.jsp"><span class="sidebar-icon">▤</span>Unidades</a>
<a class="sidebar-link active" href="dashboard"><span class="sidebar-icon">▣</span>Gestión de Contenido</a>
<div class="sidebar-label">Cuenta</div>
<a class="sidebar-link" href="acerca.jsp"><span class="sidebar-icon">○</span>Mi perfil</a>
<a class="sidebar-link" href="logout"><span class="sidebar-icon">↪</span>Cerrar sesión</a>
</aside>

<main class="dashboard-main">
<div class="dashboard-header"><div><span class="eyebrow">Área privada</span><h1>Gestión de Contenido Académico</h1><p>Carga y administra materiales de estudio y recursos para tu portafolio.</p></div><div style="display:flex;gap:7px"><button class="theme-toggle" data-theme-toggle><span class="moon">☾</span><span class="sun">☀</span></button><a class="btn btn-secondary" href="${pageContext.request.contextPath}/">Ver sitio público ↗</a></div></div>

<% if(request.getParameter("mensaje")!=null){ %><div class="alert alert-success">Operación realizada correctamente.</div><% } %>
<% if(request.getParameter("error")!=null){ %><div class="alert alert-error">No se pudo completar la operación.</div><% } %>
<% if(request.getAttribute("error")!=null){ %><div class="alert alert-error"><%=request.getAttribute("error")%></div><% } %>

<section class="stats">
<div class="card stat"><span>Materiales publicados</span><strong><%=archivos!=null?archivos.size():0%></strong></div>
<div class="card stat"><span>Rol de cuenta</span><strong style="font-size:15px"><%=usuario.getRol()%></strong></div>
<div class="card stat"><span>Estado</span><strong style="font-size:15px;color:var(--success)">Activo</strong></div>
</section>

<section class="dashboard-grid">
<div class="card panel">
<div class="panel-head"><div><h2>Nuevo Recurso de Estudio</h2><p>Publica un material para tu portafolio.</p></div></div>
<form action="subir-archivo" method="post" enctype="multipart/form-data">
<div class="form-grid">
<div class="form-group"><label for="nombre">Nombre del recurso</label><input class="form-control" type="text" id="nombre" name="nombre" placeholder="Ej. Introducción a Algoritmos" required></div>
<div class="form-group"><label for="tipo">Tipo</label><select class="form-control" id="tipo" name="tipo"><option value="pdf">PDF</option><option value="documento">Documento</option><option value="imagen">Imagen</option><option value="otro">Otro</option></select></div>
<div class="form-group full"><label for="descripcion">Descripción</label><textarea class="form-control" id="descripcion" name="descripcion" rows="3" placeholder="Describe brevemente el contenido..."></textarea></div>
<div class="form-group full"><label>Archivo</label><div class="file-drop"><div><label for="archivo">+ Seleccionar archivo<input type="file" id="archivo" name="archivo" required></label><small>PDF, imágenes o documentos · máximo configurado en el servidor</small></div></div></div>
</div>
<button class="btn btn-primary" type="submit">Publicar contenido</button>
</form>
</div>

<div class="card panel">
<div class="panel-head"><div><h2>Herramientas rápidas</h2><p>Acciones para organizar tus recursos.</p></div></div>
<div style="display:grid;gap:8px">
<button class="btn btn-secondary" style="justify-content:flex-start" data-open-modal="imageModal">▧ &nbsp; Buscar e insertar imagen</button>
<a class="btn btn-secondary" style="justify-content:flex-start" href="unidades.jsp">▤ &nbsp; Ver estructura de unidades</a>
<a class="btn btn-secondary" style="justify-content:flex-start" href="${pageContext.request.contextPath}/">⌂ &nbsp; Previsualizar portafolio</a>
</div>
<div style="margin-top:18px;padding:12px;background:var(--surface-2);border-radius:7px;border:1px solid var(--line)">
<span class="eyebrow">Sesión actual</span><p style="font-size:9px;margin-top:5px"><strong><%=usuario.getNombre()%></strong><br><span class="muted"><%=usuario.getEmail()%></span></p>
</div>
</div>
</section>

<section class="card panel" style="margin-top:14px">
<div class="panel-head"><div><h2>Material Publicado Recientemente</h2><p>Administra los archivos asociados a tu cuenta.</p></div></div>
<% if(archivos!=null && !archivos.isEmpty()){ %>
<div class="table-wrap"><table class="data-table"><thead><tr><th>Material</th><th>Tipo</th><th>Fecha</th><th>Acciones</th></tr></thead><tbody>
<% for(Archivo archivo:archivos){ %>
<tr><td><strong><%=archivo.getNombre()%></strong><br><span class="muted"><%=archivo.getDescripcion()!=null?archivo.getDescripcion():""%></span></td><td><span class="badge badge-blue"><%=archivo.getTipo()%></span></td><td><%=archivo.getCreatedAt()!=null?archivo.getCreatedAt().toLocalDate():""%></td><td><div class="table-actions"><a class="icon-btn" title="Descargar" href="descargar-archivo?id=<%=archivo.getId()%>">↓</a><form action="eliminar-archivo" method="post" style="display:inline"><input type="hidden" name="id" value="<%=archivo.getId()%>"><button class="icon-btn" title="Eliminar" type="submit">×</button></form></div></td></tr>
<% } %></tbody></table></div>
<% }else{ %><div class="empty">No tienes materiales publicados todavía.</div><% } %>
</section>
</main></div>

<div class="modal-backdrop" id="imageModal">
<div class="modal">
<div class="modal-head"><div><h2>Buscar e insertar imagen</h2><p>Selecciona una imagen que ya hayas subido al portafolio.</p></div><button class="close-modal" data-close-modal>×</button></div>
<div class="search-box"><span>⌕</span><input class="form-control" data-image-search placeholder="Buscar por nombre..."></div>
<div class="image-grid">
<%
boolean hayImagen=false;
if(archivos!=null){for(Archivo archivo:archivos){if("imagen".equalsIgnoreCase(archivo.getTipo())){hayImagen=true;
%>
<div class="image-option" data-image-item><img src="${pageContext.request.contextPath}<%=archivo.getUrl()%>" alt="<%=archivo.getNombre()%>"><div class="image-info"><strong><%=archivo.getNombre()%></strong><button type="button" data-select-image="${pageContext.request.contextPath}<%=archivo.getUrl()%>">Seleccionar</button></div></div>
<%}}}
if(!hayImagen){%><div class="empty" style="grid-column:1/-1">No hay imágenes disponibles. Sube una imagen desde “Nuevo Recurso de Estudio”.</div><%}%>
</div>
</div></div>
<script src="js/theme.js"></script>
</body></html>
