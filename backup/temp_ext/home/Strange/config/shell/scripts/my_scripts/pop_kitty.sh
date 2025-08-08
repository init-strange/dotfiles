
pop_kitty () 
{ 
    kitty --detach sh -c "cd \"$PWD\"; exec bash"
}

bind -x '"\eOR":pop_kitty'

