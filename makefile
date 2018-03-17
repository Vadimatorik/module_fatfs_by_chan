ifndef MODULE_FAT_FS_OPTIMIZATION
	MODULE_FAT_FS_OPTIMIZATION = -g3 -O0
endif

#**********************************************************************
# Для сборки FatFS.
#**********************************************************************
FAT_FS_H_FILE			:= $(shell find module_fatfs_by_chan/ -maxdepth 3 -type f -name "*.h" )
FAT_FS_CPP_FILE			:= $(shell find module_fatfs_by_chan/ -maxdepth 3 -type f -name "*.c" )
FAT_FS_DIR				:= $(shell find module_fatfs_by_chan/ -maxdepth 3 -type d -name "*" )
FAT_FS_PATH				:= $(addprefix -I, $(FAT_FS_DIR))
FAT_FS_OBJ_FILE			:= $(addprefix build/obj/, $(FAT_FS_CPP_FILE))
FAT_FS_OBJ_FILE			:= $(patsubst %.c, %.o, $(FAT_FS_OBJ_FILE))

PROJECT_PATH			+= $(FAT_FS_PATH)
PROJECT_OBJ_FILE		+= $(FAT_FS_OBJ_FILE)

build/obj/module_fatfs_by_chan/%.o:	module_fatfs_by_chan/%.c $(USER_CFG_H_FILE)
	@echo [CC] $<
	@mkdir -p $(dir $@)
	@$(CC) $(C_FLAGS) $(PROJECT_PATH) $(USER_CFG_PATH) $(MODULE_FAT_FS_OPTIMIZATION) -c $< -o $@

# Добавляем к общим переменным проекта.
