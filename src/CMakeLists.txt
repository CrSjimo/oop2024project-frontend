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

foreach(_file IN LISTS _qml_files)
    file(STRINGS ${_file} _file_content LIMIT_COUNT 1 REGEX "pragma Singleton")

    if(_file_content)
        set_source_files_properties(${_file}
            PROPERTIES
                QT_QML_SINGLETON_TYPE TRUE)
    endif()
endforeach()



qt_add_qml_module(${PROJECT_NAME}
    URI dev.sjimo.oop2024projectfrontend
    QML_FILES
        ${_qml_files}
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Gui Qt6::Quick)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/util)