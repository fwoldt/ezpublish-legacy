{section show=eq(ezpreference('content_structure_menu'),'on')}
<h4>{"Content structure"|i18n("design/admin/layout")} <a class="showhide" href={"/user/preferences/set/content_structure_menu/off"|ezurl}>[-]</a></h4>
<div id="contentstructure">
    {include uri="design:contentstructuremenu/content_structure_menu.tpl" custom_root_node_id=ezini( 'NodeSettings', 'MediaRootNode', 'content.ini')}
</div>
{section-else}
<h4>{"Content structure"|i18n("design/admin/layout")} <a class="showhide" href={"/user/preferences/set/content_structure_menu/on"|ezurl}>[+]</a></h4>
{/section}

<ul>
    <li><a href={concat("/content/trash/",ezini('NodeSettings','RootNode','content.ini'))|ezurl}>{"Trash"|i18n("design/admin/layout")}</a></li>
</ul>