file(GLOB_RECURSE _src *.cpp *.h)

qt_add_executable(${PROJECT_NAME}
    ${_src}
)

file(GLOB_RECURSE _qml_files_abs *.qml *.js *.mjs)

set(_qml_files)
foreach (_file IN LISTS _qml_files_abs)
    file(RELATIVE_PATH _rel_path ${CMAKE_CURRENT_SOURCE_DIR} ${_file})
    list(APPEND _qml_files ${_rel_path})
endforeach ()

qt_add_qml_module(${PROJECT_NAME}
    URI dev.sjimo.oop2024projectfrontend
    QML_FILES
        ${_qml_files}
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Gui Qt6::Quick)