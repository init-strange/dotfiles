# Always operate relative to where the script is

Project_name="game"
Script_dir="$(pwd)" 
Build_dir="build"
Bin_dir="$Build_dir/bin"
Src_dir=("src" "Game/src")
Include_dir=("include" "Game/include")

C_flags="-Wall -Wextra -Wno-unused-parameter -std=c11 -g -Og"
Sdl_flags=$(sdl2-config --cflags --libs)

Action="$1"

if [[ ! -d "src" && ! -d "Game/src" ]]; then
    echo "No source directories found. Are you in the project root?"
    exit 1
fi
Src_files=()

if [[ -z "$Action" ]]; then
    Action="build"
fi
if [[ "$Action" == "clean" ]]; then
    echo "Cleaning ..."
    rm -rf "$Build_dir"
    echo "cleaned"
    exit 0
fi
if [[ "$Action" == "run" ]]; then
    if [[ ! -f "$Bin_dir/$Project_name" ]]; then
        echo "Binary not found. Run './build.sh' or './build.sh rebuild' first."
        exit 1
    fi
    "$Bin_dir/$Project_name"
    exit $?
fi

if [[ "$Action" == "debug" ]]; then
    if [[ ! -f "$Bin_dir/$Project_name" ]]; then
        echo "Binary not found. Build first."
        exit 1
    fi
    gdb "$Bin_dir/$Project_name"
    exit $?
fi
if [[ "$Action" == "build" || "$Action" == "rebuild" ]]; then

    if [[ "$Action" == "rebuild" ]]; then
        echo "Rebuilding..."
        rm -rf "$Build_dir"
        echo "Cleaned $Build_dir"
    fi
    mkdir -p "$Build_dir" "$Bin_dir"

    for dir in "${Src_dir[@]}"; do 
        for file in "$dir"/*.c; do 
            [[ -f "$file" ]] && Src_files+=("$file")
        done
    done
    Include_flags=""
    for inc in "${Include_dir[@]}"; do
        Include_flags+=" -I$inc"
    done
Object_files=()
for dir in "${Src_dir[@]}"; do
    for src_file in "$dir"/*.c; do
        [[ -f "$src_file" ]] || continue

        base_name=$(basename "$src_file" .c)
        obj_file="$Build_dir/$base_name.o"

        # Check if object file is missing or older than source or any header
        recompile=false
        [[ ! -f "$obj_file" || "$src_file" -nt "$obj_file" ]] && recompile=true

        for inc_dir in "${Include_dir[@]}"; do
            for header in "$inc_dir"/*.h; do
                [[ -f "$header" && "$header" -nt "$obj_file" ]] && recompile=true
            done
        done

        if [[ "$recompile" == true ]]; then
            echo " Compiling $src_file → $obj_file"
            gcc -c "$src_file" -o "$obj_file" $Include_flags $C_flags $Sdl_flags || {
                echo "Compilation failed for $src_file"
                exit 1
            }
        else
            echo " Skipping $src_file (up-to-date)"
        fi

        Object_files+=("$obj_file")
    done
done

if [[ ${#Object_files[@]} -eq 0 ]]; then
    echo "No source files found. Are you in the right directory?"
    exit 1
fi
    echo "Linking..."
    gcc "${Object_files[@]}" -o "$Bin_dir/$Project_name" $Sdl_flags

    if [[ $? -eq 0 ]]; then
        echo "Build complete: $Bin_dir/$Project_name"
    else
        echo "Build failed."
    fi

fi

