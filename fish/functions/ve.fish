function ve -d "Create or source Python venv"
    # Check if we're already in a virtualenv
    if set -q VIRTUAL_ENV
        deactivate
        echo "Deactivated virtual enviroment"
        return 0
    end

    # Check if env directory exists
    if test -d "./env"
        # Source the activate script
        source ./env/bin/activate.fish
        echo "Activated existing virtual environment"
    else
        # Create new virtual environment
        echo "Creating new Python virtual environment..."
        python -m venv env
        
        # Check if creation was successful
        if test $status -eq 0
            source ./env/bin/activate.fish
            echo "Created and activated new virtual environment"
            
            # Optionally upgrade pip
            #python -m pip install --upgrade pip
        else
            echo "Failed to create virtual environment"
            return 1
        end
    end
end
