lua << EOF
require('kommentary.config').configure_language("elixir", {
    single_line_comment_string = "#",
    multi_line_comment_strings = {"\"\"\"", "\"\"\""},
    prefer_single_line_comment = true
})
EOF
