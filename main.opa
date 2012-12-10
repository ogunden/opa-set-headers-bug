import jQueryUI

type item = {
  int id,
  int user_id,
  string name,
}

database testitems {
  item /all[{id}]
}

type user = {
  int user_id
}

function add_item(user, item_id, name) {
  /testitems/all[{id:item_id}]
    <- { id:item_id, user_id:user.user_id, ~name}
}

function get_list_for_user(user) {
  add_item(user, 0, "item0");
  add_item(user, 2, "item2");
  dbset(item,_) is = /testitems/all[user_id == user.user_id];
  it = DbSet.iterator(is);
  Iter.to_list(it)
}

function update_sorting(user, _lst) {
  // just hit the DB for testing
  _l = get_list_for_user(user);
  void
}

function int_of_string_opt(s) {
  Parser.try_parse(Rule.integer, s)
}

@async function make_sortable(user) {
  function on_sort_update(user) {
    children =
      Dom.split(Dom.select_children(#itemlist_ul));
    l = List.filter_map(
        (function(d) {
           id = Dom.get_id(d);
           match (int_of_string_opt(id)) {
           case { none }:
             Log.error(
              "sortable",
              ("int_of_string(" ^ id) ^ ")"
             );
             {none}
           case x: x
           }
        }),  children);
    update_sorting(user, l)
  };
  jQueryUI.Sortable.mk_sortable(#itemlist_ul);
  jQueryUI.Sortable.disable_selection(#itemlist_ul);
  jQueryUI.Sortable.on_update(#itemlist_ul,
    {function() { on_sort_update(user) }}
  )
}

function render_list(user) {
  l = get_list_for_user(user);
  function row(item) {
    <li id="{item.id}">
     {item.name}
    </li>
  };
  html =
    <>
     <ul id="itemlist_ul"
         onready={function(_) { make_sortable(user) }}>
      {Xhtml.createFragment(List.map(row, l))}
     </ul>
    </>;
  #itemlist = html
}

function page() {
  user = { user_id:0 };
  <div onready={function(_) { render_list(user) }}
    id="itemlist"/>
}

Server.start(Server.http, {title:"sortabletest", ~page})
