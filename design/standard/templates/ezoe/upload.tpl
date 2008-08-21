{set scope=global persistent_variable=hash('title', 'Upload new'|i18n('design/standard/ezoe'),
                                           'scripts', array('javascript/ezoe/ez_core.js',
                                                            'javascript/ezoe/ez_core_animation.js',
                                                            'javascript/ezoe/ez_core_accordion.js',
                                                            'javascript/ezoe/popup_utils.js'),
                                           'css', array()
                                           )}
<script type="text/javascript">
<!--
var contentType = '{$content_type}', classFilter = ez.$c();

{foreach $class_filter_array as $class_filter}
    classFilter.push('{$class_filter}');
{/foreach}
    
{literal}

tinyMCEPopup.onInit.add( function(){
    var slides = ez.$$('div.panel'), navigation = ez.$$('#tabs li.tab');
    slides.accordion( navigation, {duration: 100, transition: ez.fx.sinoidal, accordionAutoFocusTag: 'input[type=text]'}, {opacity: 0, display: 'none'} );
    // custom link generator, to redirect links to browse view if not in browse view
    eZOEPopupUtils.settings.browseLinkGenerator = function( n, mode, ed )
    {
        if ( n.children_count )
        {
           tag = document.createElement("a");
           tag.setAttribute('href', 'JavaScript:eZOEPopupUtils.browse(' + n.node_id + ');');
           tag.setAttribute('title', ed.getLang('browse') );
           if ( mode !== 'browse' ) ez.$( tag ).addEvent('click', function(){ slides.accordionGoto( 2 ); });
           return tag;
        }
        return document.createElement("span");
    };
});

if ( contentType === 'image' )
{
    eZOEPopupUtils.settings.browseClassGenerator = function( n, hasImage ){
        if ( hasImage && classFilter.indexOf( n.class_identifier ) !== -1 )
            return '';
        if ( n.children_count )
            return 'node_not_image';
        return 'node_not_image node_fadeout';
    };
}

-->
</script>
{/literal}

<div class="upload-view">
    <form action={concat('ezoe/upload/', $object_id, '/', $object_version, '/auto/1' )|ezurl} method="post" target="embed_upload" name="EmbedForm" id="EmbedForm" enctype="multipart/form-data" onsubmit="document.getElementById('upload_in_progress').style.display = '';">

        <div id="tabs" class="tabs">
        <ul>
            <li class="tab"><span><a href="JavaScript:void(0);">{'Upload'|i18n('design/admin/content/upload')}</a></span></li>
            <li class="tab"><span><a href="JavaScript:void(0);">{'Search'|i18n('design/admin/content/search')}</a></span></li>
            <li class="tab"><span><a href="JavaScript:void(0);">{'Browse'|i18n('design/standard/ezoe')}</a></span></li>
            <li class="tab"><span><a href="JavaScript:void(0);">{'Bookmarks'|i18n( 'design/admin/content/browse' )}</a></span></li>
        </ul>
        </div>

<div class="panel_wrapper" style="min-height: 360px;">
        <div class="panel">
            <table class="properties">
                <tr>
                    <td class="column1"><label id="srclabel" for="fileName">{'File'|i18n('design/standard/ezoe')}</label></td>
                    <td colspan="2"><input name="fileName" type="file" id="fileName" value="" /></td>
                </tr>
                <tr id="embedlistsrcrow">
                    <td class="column1"><label for="location">{'Location'|i18n('design/standard/ezoe')}</label></td>
                    <td colspan="2" id="embedlistsrccontainer">
                      <select name="location" id="location">
                        <option value="auto">{'Automatic'|i18n('design/standard/ezoe')}</option>

                        {if $object.published}
                            <option value="{$object.main_node_id}">{$object.name} (this)</option>
                        {/if}

                        {def $root_node_value = ezini( 'LocationSettings', 'RootNode', 'upload.ini' )
                             $root_node = cond( $root_node_value|is_numeric, fetch( 'content', 'node', hash( 'node_id', $root_node_value ) ),
                                             fetch( 'content', 'node', hash( 'node_path', $root_node_value ) ) )
                             $selection_list = fetch( 'content', 'tree',
                                                     hash( 'parent_node_id', $root_node.node_id,
                                                           'class_filter_type', include,
                                                           'class_filter_array', ezini( 'LocationSettings', 'ClassList', 'upload.ini' ),
                                                           'depth', ezini( 'LocationSettings', 'MaxDepth', 'upload.ini' ),
                                                           'depth_operator', 'lt',
                                                           'load_data_map', false(),
                                                           'limit', ezini( 'LocationSettings', 'MaxItems', 'upload.ini' ) ) )}
                        {foreach $selection_list as $item}
                        {if $item.can_create}
                            <option value="{$item.node_id}">{'&nbsp;'|repeat( sub( $item.depth, $root_node.depth, 1 ) )}{$item.name|wash}</option>
                        {/if}
                        {/foreach}

                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class="column1"><label id="titlelabel" for="objectName">{'Name'|i18n('design/standard/ezoe')}</label></td> 
                    <td colspan="2"><input id="objectName" name="objectName" type="text" value="" /></td> 
                </tr>
                {if $content_type|eq('image')}
                <tr>
                    <td class="column1"><label id="alttextlabel" for="objectAltText">{'Alternative text'|i18n('design/standard/ezoe')}</label></td> 
                    <td colspan="2"><input id="objectAltText" name="ContentObjectAttribute_image" type="text" value="" size="32" /></td>
                </tr>
                <tr>
                    <td class="column1"><label id="captionlabel" for="objectCaption">{'Caption'|i18n('design/standard/ezoe')}</label></td> 
                    <td colspan="2"><input id="objectCaption" name="ContentObjectAttribute_caption" type="text" value="" size="32" /></td>
                </tr>
                {else}
                <tr>
                    <td class="column1"><label id="descriptionlabel" for="objectDescription">{'Description'|i18n('design/standard/ezoe')}</label></td> 
                    <td colspan="2"><input id="objectDescription" name="ContentObjectAttribute_description" type="text" value="" size="32" /></td> 
                </tr>
                {/if}
                <tr> 
                    <td colspan="3">
                    <input id="uploadButton" name="uploadButton" type="submit" value="{'Upload local file'|i18n('design/standard/ezoe')}" />
                    <span id="upload_in_progress" style="display: none; color: #666; background: #fff url({"stylesheets/skins/default/img/progress.gif"|ezdesign('single')}) no-repeat top left scroll; padding-left: 32px;">{'Upload is in progress, it may take a few seconds...'|i18n('design/standard/ezoe')}</span>
                    </td> 
                </tr>
            </table>

            <iframe id="embed_upload" name="embed_upload" frameborder="0" scrolling="no" style="border: 0; width: 99%; height: 30px; margin: 0; overflow: auto; overflow-x: hidden;"></iframe>

            {if $related_contentobjects|count|gt( 0 )}
                {* Related images *}
                {if and( $content_type|eq('image'), $grouped_related_contentobjects.images|count|gt( 0 ))}
                <div class="block">
                <h2>{'Related images'|i18n('design/standard/ezoe')}</h2>
                    {foreach $grouped_related_contentobjects.images as $img}

                    <div class="image-thumbnail-item">
                        <a title="{$img.object.name|wash}" href="JavaScript:eZOEPopupUtils.selectByEmbedId( {$img.object.id} )" class="contenttype_image">
                        {attribute_view_gui attribute=$img.object.data_map.image image_class=small}
                        </a>
                    </div>
                    {/foreach}
                </div>
                {/if}
            
                {* Related files *}
                {*if and( $content_type|eq('file'), $grouped_related_contentobjects.files|count|gt( 0 ))*}
                {if and( $content_type|eq('object'), $grouped_related_contentobjects.files|count|gt( 0 ))}
                <div class="block">
                <h2>{'Related files'|i18n('design/standard/ezoe')}</h2>
                        <table class="list" cellspacing="0">
                        <tr>
                            <th class="name">{'Name'|i18n( 'design/admin/content/edit' )}</th>
                            <th class="class">{'File type'|i18n( 'design/admin/content/edit' )}</th>
                            <th class="filesize">{'Size'|i18n( 'design/admin/content/edit' )}</th>
                        </tr>
                        {foreach $grouped_related_contentobjects.files as $file sequence array( bglight, bgdark ) as $sequence}
                            <tr class="{$sequence}">
                                <td class="name">{$file.object.class_name|class_icon( small, $file.object.class_name )}&nbsp;<a href="JavaScript:eZOEPopupUtils.selectByEmbedId( {$file.object.id} )">{$file.object.name|wash}</a></td>
                                <td class="filetype">{$file.object.data_map.file.content.mime_type|wash}</td>
                                <td class="filesize">{$file.object.data_map.file.content.filesize|si( byte )}</td>
                            </tr>
                        {/foreach}
                        </table>
                </div>
                {/if}
            
                {* Related objects *}
                {if and( $content_type|eq('object'), $grouped_related_contentobjects.objects|count|gt( 0 ))}
                <div class="block">
                <h2>{'Related content'|i18n('design/standard/ezoe')}</h2>
                        <table class="list" cellspacing="0">
                        <tr>
                            <th class="name">{'Name'|i18n( 'design/admin/content/edit' )}</th>
                            <th class="class">{'Type'|i18n( 'design/admin/content/edit' )}</th>
                        </tr>
                        {foreach $grouped_related_contentobjects.objects as $relation sequence array( bglight, bgdark ) as $sequence}
                            <tr class="{$sequence}">
                                <td class="name">{$relation.object.class_name|class_icon( small, $relation.object.class_name )}&nbsp;<a href="JavaScript:eZOEPopupUtils.selectByEmbedId( {$relation.object.id} )">{$relation.object.name|wash}</a></td>
                                <td class="class">{$relation.object.class_name|wash}</td>
                            </tr>
                        {/foreach}
                        </table>
                </div>
                {/if}
            {else}
            <div class="block">
                <p>{"There are no related objects."|i18n("design/standard/ezoe")}</p>
            </div>
            {/if}
        </div>

{include uri="design:ezoe/box_search.tpl" embed_mode=false() class_filter_array=$class_filter_array}

{include uri="design:ezoe/box_browse.tpl" embed_mode=false() class_filter_array=$class_filter_array}

{include uri="design:ezoe/box_bookmarks.tpl" embed_mode=false()}

</div>
     </form>
</div>