if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet if if(".st."condition".et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
exec "Snippet elseif elseif(".st."condition".et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
exec "Snippet else else<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
exec "Snippet ifelse if(".st."condition".et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>else<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
exec "Snippet if? $".st."retVal".et." = ".st."condition".et." ? ".st."a".et." : ".st."b".et.";<CR>".st.et
exec "Snippet switch switch(".st."variable".et.")<CR>{<CR><Tab>case ".st."value".et.":<CR><Tab>".st.et."<CR>break;<CR><BS>".st.et."<CR>default:<CR><Tab>".st.et."<CR>break;<CR><BS><BS>}<CR>".st.et
exec "Snippet case case '".st."variable".et."':<CR><Tab>".st.et."<CR>break;<CR><BS>".st.et

exec "Snippet for for($".st."i".et." = ".st.et."; $".st."i".et." < ".st.et."; $".st."i".et."++)<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
exec "Snippet while while(".st.et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
exec "Snippet do do<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>while(".st.et.");<CR>".st.et
exec "Snippet foreach foreach($".st."variable".et." as $".st."key".et." => $".st."value".et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et

exec "Snippet req require '".st."file".et."';<CR>".st.et
exec "Snippet reqonce require_once '".st."file".et."';<CR>".st.et

exec "Snippet inconce include_once '".st."file".et."';<CR>".st.et
exec "Snippet inc include '".st."file".et."';<CR>".st.et

exec "Snippet <? <?php<CR><CR>".st.et

"exec "Snippet class #doc<CR>#classname:".st."ClassName".et."<CR>#scope:".st."PUBLIC".et."<CR>#<CR>#/doc<CR><CR>class ".st."ClassName".et." ".st."extendsAnotherClass".et."<CR>{<CR>#internal variables<CR><CR>#Constructor<CR>function __construct ( ".st."argument".et.")<CR>{<CR>".st.et."<CR>}<CR>###<CR><CR>}<CR>###".st.et
exec "Snippet class class ".st."ClassName".et."<CR>{<CR><Tab>protected function __construct(".st.et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR><BS>}<CR>".st.et

exec "Snippet print print '".st."string".et."'".st.et.";".st.et."<CR>".st.et

exec "Snippet GET $_GET['".st."variable".et."']".st.et
exec "Snippet POST $_POST['".st."variable".et."']".st.et

exec "Snippet function ".st."public".et." function ".st."FunctionName".et."(".st.et.")<CR>{<CR><Tab>".st.et."<CR><BS>}<CR>".st.et
"exec "Snippet array $".st."arrayName".et." = array( '".st.et."',".st.et." );".st.et
"exec "Snippet -globals $GLOBALS['".st."variable".et."']".st.et.st."something".et.st.et.";<CR>".st.et
