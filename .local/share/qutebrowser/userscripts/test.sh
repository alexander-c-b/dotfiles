#!/bin/sh
tee $QUTE_FIFO << END
message-info 'mode:               $QUTE_MODE'
message-info 'user agent:         $QUTE_USER_AGENT'
message-info 'fifo:               $QUTE_FIFO'
message-info 'html:               $QUTE_HTML'
message-info 'text:               $QUTE_TEXT'
message-info 'config dir:         $QUTE_CONFIG_DIR'
message-info 'data dir:           $QUTE_DATA_DIR'
message-info 'download dir:       $QUTE_DOWNLOAD_DIR'
message-info 'commandline text:   $QUTE_COMMANDLINE_TEXT'
message-info 'url:                $QUTE_URL'
message-info 'title:              $QUTE_TITLE'
message-info 'selected text:      $QUTE_SELECTED_TEXT'
message-info 'count:              $QUTE_COUNT'
message-info 'selected html:      $QUTE_SELECTED_HTML'
END
