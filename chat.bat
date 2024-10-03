@echo off
setlocal enabledelayedexpansion
set "userName="
set "memoryFile=memories.txt"

:: Set color scheme
color 0A

:: Welcome and name input
cls
echo ==============================
echo Welcome to the Chat Application!
echo ==============================
if not defined userName (
    set /p userName="Please enter your name: "
    echo.
    echo Hello, %userName%! Let's start chatting!
    echo ==============================
    echo.
)

:chat_loop
:: User input
set /p userInput="You: "

:: Handle empty input
if "!userInput!"=="" (
    echo Chatbot: Please enter something! I can't respond to nothing.
    echo.
    goto chat_loop
)

:: Check for keywords in the user input
set "foundResponse=0"

:: Handle time command
echo !userInput! | findstr /i "time" >nul
if not errorlevel 1 (
    echo Chatbot: The current time is %time%.
    set foundResponse=1
)

:: Handle date command
echo !userInput! | findstr /i "date" >nul
if not errorlevel 1 (
    echo Chatbot: Today's date is %date%.
    set foundResponse=1
)

:: Handle joke command
echo !userInput! | findstr /i "joke" >nul
if not errorlevel 1 (
    call :tellJoke
    set foundResponse=1
)

:: Handle remember command
echo !userInput! | findstr /i "remember" >nul
if not errorlevel 1 (
    set "memory=!userInput:remember =!"
    if "!memory!"=="" (
        echo Chatbot: Please provide something to remember after 'remember'.
    ) else (
        echo !memory! >> "%memoryFile%"
        echo Chatbot: I've remembered: !memory!.
    )
    set foundResponse=1
)

:: Handle recall command
echo !userInput! | findstr /i "recall" >nul
if not errorlevel 1 (
    set "keyword=!userInput:recall =!"
    if "!keyword!"=="" (
        echo Chatbot: Please specify a keyword to recall.
    ) else (
        echo Chatbot: Here are your memories matching "%keyword%":
        set "found=0"
        for /f "tokens=*" %%a in (%memoryFile%) do (
            echo %%a | findstr /i "!keyword!" >nul
            if not errorlevel 1 (
                echo - %%a
                set "found=1"
            )
        )
        if "!found!"=="0" (
            echo - No memories found for that keyword.
        )
    )
    set foundResponse=1
)

:: Handle help command
echo !userInput! | findstr /i "help" >nul
if not errorlevel 1 (
    echo Chatbot: You can ask me about the time, date, tell a joke, remember something, or recall your memories.
    set foundResponse=1
)

:: Handle exit command
if /i "!userInput!"=="bye" (
    echo Chatbot: Goodbye, %userName%! Have a great day!
    exit /b
)

:: If no recognized command was found
if !foundResponse! == 0 (
    echo Chatbot: I'm sorry, I didn't understand that. Try asking about the time, date, or tell me a joke!
)

echo.
goto chat_loop

:: Jokes subroutine
:tellJoke
set /a randomNum=%random% %% 3
if %randomNum%==0 (
    echo Chatbot: Why don’t scientists trust atoms? Because they make up everything!
) else if %randomNum%==1 (
    echo Chatbot: I told my computer I needed a break, and now it won’t stop sending me Kit-Kats!
) else (
    echo Chatbot: Why did the programmer quit his job? Because he didn't get arrays!
)
exit /b
