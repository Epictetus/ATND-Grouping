class Grouping
  
  # シャッフルボタンの状態を変更する
  @updateShuffleBtn: ()->
  
    $$event_url = $('#grouping_event_url')
    $$groupings_count = $('#grouping_groupings_count')[0]
    
    if $$groupings_count.selectedIndex == 0 or $$event_url.val() == $$event_url.attr('title') or $$event_url.val() == ''
      # シャッフルボタンを無効にする
      $('#btn_shuffle').attr('disabled','disabled')
      $('li.shuffle').attr('disabled','disabled')
      $('#btn_shuffle').css('display','none')
    else
      # シャッフルボタンを有効にする
      $('#btn_shuffle').removeAttr('disabled')
      $('li.shuffle').removeAttr('disabled')
      $('#btn_shuffle').css('display','block')
  
  @init: ()->
    
    $('#loading')
      .ajaxStart ()->
        $(this).fadeIn()
      .ajaxStop ()->
        $(this).fadeOut()
    
    # イベントURL
    $('#grouping_event_url').change(->
      Grouping.updateShuffleBtn()
    )
    
    # グループ数
    $('#grouping_groupings_count').change(->
      Grouping.updateShuffleBtn()
    )
          
    $('#new_grouping')
      .live 'ajax:complete', (event, data, status, xhr)->
        $('#results').html(data.responseText)
    
    # シャッフルボタン
    $('li.shuffle').live('click', (e)->
      e.preventDefault()
      $('#new_grouping').submit() unless $(@).attr('disabled')
    )
      
    $('li.result').live 'click', (e)->
      e.preventDefault()
      json = $.parseJSON($('#results-json').text())
      callback = (data,status)->
        window.location.href = "/groupings/#{data._id}"
      $.post '/groupings', {grouping: json}, callback, 'json'
    
    $('#grouping_groupings_count').change()

window.Grouping = Grouping

$(document).ready ->
  $("#grouping_event_url").blur(->
    $$ = $(this)
    $$.css({"color": "#888","font-size": "14px","text-weight": "normal"}).val $$.attr("title")  if $$.val() is "" or $$.val() is $$.attr("title")
  ).focus(->
    $$ = $(this)
    $$.css("color", "#000").val ""  if $$.val() is $$.attr("title")
  ).parents("form:first").submit(->
    $$ = $("#grouping_event_url")
    $$.triggerHandler "focus"  if $$.val() is $$.attr("title")
  ).end().blur()