#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/760856492/spinlock.o ${OBJECTDIR}/_ext/760856492/interrupt.o ${OBJECTDIR}/_ext/760856492/ctxswitch.o ${OBJECTDIR}/_ext/760856492/simplemm.o ${OBJECTDIR}/_ext/760856492/main.o ${OBJECTDIR}/_ext/760856492/init.o ${OBJECTDIR}/_ext/760856492/mutex.o ${OBJECTDIR}/_ext/760856492/event.o ${OBJECTDIR}/_ext/760856492/fubar.o ${OBJECTDIR}/_ext/760856492/mmregion.o ${OBJECTDIR}/_ext/760856492/pcr.o ${OBJECTDIR}/_ext/760856492/exception.o ${OBJECTDIR}/_ext/760856492/addrmap.o ${OBJECTDIR}/_ext/760856492/syscall.o ${OBJECTDIR}/_ext/760856492/idle.o ${OBJECTDIR}/_ext/760856492/xmips.o ${OBJECTDIR}/_ext/760856492/serial.o ${OBJECTDIR}/_ext/760856492/iomgr.o ${OBJECTDIR}/_ext/760856492/debug.o ${OBJECTDIR}/_ext/760856492/drv_14seg.o ${OBJECTDIR}/_ext/760856492/numlib.o ${OBJECTDIR}/_ext/760856492/andytest.o ${OBJECTDIR}/_ext/760856492/drv_sdcard.o ${OBJECTDIR}/_ext/760856492/wait.o ${OBJECTDIR}/_ext/1041809461/stdlib.o ${OBJECTDIR}/_ext/1041809461/shell_init.o ${OBJECTDIR}/_ext/1041809461/interpreter.o ${OBJECTDIR}/_ext/1041809461/blink.o ${OBJECTDIR}/_ext/1041809461/trampoline.o ${OBJECTDIR}/_ext/760856492/fs_jankyfs.o ${OBJECTDIR}/_ext/760856492/file.o ${OBJECTDIR}/_ext/760856492/utils.o ${OBJECTDIR}/_ext/1041809461/say.o ${OBJECTDIR}/_ext/1041809461/ls.o ${OBJECTDIR}/_ext/1041809461/cat.o ${OBJECTDIR}/_ext/760856492/config.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/760856492/spinlock.o.d ${OBJECTDIR}/_ext/760856492/interrupt.o.d ${OBJECTDIR}/_ext/760856492/ctxswitch.o.d ${OBJECTDIR}/_ext/760856492/simplemm.o.d ${OBJECTDIR}/_ext/760856492/main.o.d ${OBJECTDIR}/_ext/760856492/init.o.d ${OBJECTDIR}/_ext/760856492/mutex.o.d ${OBJECTDIR}/_ext/760856492/event.o.d ${OBJECTDIR}/_ext/760856492/fubar.o.d ${OBJECTDIR}/_ext/760856492/mmregion.o.d ${OBJECTDIR}/_ext/760856492/pcr.o.d ${OBJECTDIR}/_ext/760856492/exception.o.d ${OBJECTDIR}/_ext/760856492/addrmap.o.d ${OBJECTDIR}/_ext/760856492/syscall.o.d ${OBJECTDIR}/_ext/760856492/idle.o.d ${OBJECTDIR}/_ext/760856492/xmips.o.d ${OBJECTDIR}/_ext/760856492/serial.o.d ${OBJECTDIR}/_ext/760856492/iomgr.o.d ${OBJECTDIR}/_ext/760856492/debug.o.d ${OBJECTDIR}/_ext/760856492/drv_14seg.o.d ${OBJECTDIR}/_ext/760856492/numlib.o.d ${OBJECTDIR}/_ext/760856492/andytest.o.d ${OBJECTDIR}/_ext/760856492/drv_sdcard.o.d ${OBJECTDIR}/_ext/760856492/wait.o.d ${OBJECTDIR}/_ext/1041809461/stdlib.o.d ${OBJECTDIR}/_ext/1041809461/shell_init.o.d ${OBJECTDIR}/_ext/1041809461/interpreter.o.d ${OBJECTDIR}/_ext/1041809461/blink.o.d ${OBJECTDIR}/_ext/1041809461/trampoline.o.d ${OBJECTDIR}/_ext/760856492/fs_jankyfs.o.d ${OBJECTDIR}/_ext/760856492/file.o.d ${OBJECTDIR}/_ext/760856492/utils.o.d ${OBJECTDIR}/_ext/1041809461/say.o.d ${OBJECTDIR}/_ext/1041809461/ls.o.d ${OBJECTDIR}/_ext/1041809461/cat.o.d ${OBJECTDIR}/_ext/760856492/config.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/760856492/spinlock.o ${OBJECTDIR}/_ext/760856492/interrupt.o ${OBJECTDIR}/_ext/760856492/ctxswitch.o ${OBJECTDIR}/_ext/760856492/simplemm.o ${OBJECTDIR}/_ext/760856492/main.o ${OBJECTDIR}/_ext/760856492/init.o ${OBJECTDIR}/_ext/760856492/mutex.o ${OBJECTDIR}/_ext/760856492/event.o ${OBJECTDIR}/_ext/760856492/fubar.o ${OBJECTDIR}/_ext/760856492/mmregion.o ${OBJECTDIR}/_ext/760856492/pcr.o ${OBJECTDIR}/_ext/760856492/exception.o ${OBJECTDIR}/_ext/760856492/addrmap.o ${OBJECTDIR}/_ext/760856492/syscall.o ${OBJECTDIR}/_ext/760856492/idle.o ${OBJECTDIR}/_ext/760856492/xmips.o ${OBJECTDIR}/_ext/760856492/serial.o ${OBJECTDIR}/_ext/760856492/iomgr.o ${OBJECTDIR}/_ext/760856492/debug.o ${OBJECTDIR}/_ext/760856492/drv_14seg.o ${OBJECTDIR}/_ext/760856492/numlib.o ${OBJECTDIR}/_ext/760856492/andytest.o ${OBJECTDIR}/_ext/760856492/drv_sdcard.o ${OBJECTDIR}/_ext/760856492/wait.o ${OBJECTDIR}/_ext/1041809461/stdlib.o ${OBJECTDIR}/_ext/1041809461/shell_init.o ${OBJECTDIR}/_ext/1041809461/interpreter.o ${OBJECTDIR}/_ext/1041809461/blink.o ${OBJECTDIR}/_ext/1041809461/trampoline.o ${OBJECTDIR}/_ext/760856492/fs_jankyfs.o ${OBJECTDIR}/_ext/760856492/file.o ${OBJECTDIR}/_ext/760856492/utils.o ${OBJECTDIR}/_ext/1041809461/say.o ${OBJECTDIR}/_ext/1041809461/ls.o ${OBJECTDIR}/_ext/1041809461/cat.o ${OBJECTDIR}/_ext/760856492/config.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE} ${MAKE_OPTIONS} -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=32MX795F512L
MP_LINKER_FILE_OPTION=
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/760856492/spinlock.o: ../krnl/spinlock.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/spinlock.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/spinlock.o ../krnl/spinlock.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/spinlock.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/interrupt.o: ../krnl/interrupt.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/interrupt.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/interrupt.o ../krnl/interrupt.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/interrupt.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/ctxswitch.o: ../krnl/ctxswitch.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/ctxswitch.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/ctxswitch.o ../krnl/ctxswitch.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/ctxswitch.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/simplemm.o: ../krnl/simplemm.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/simplemm.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/simplemm.o ../krnl/simplemm.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/simplemm.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/main.o: ../krnl/main.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/main.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/main.o ../krnl/main.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/main.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/init.o: ../krnl/init.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/init.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/init.o ../krnl/init.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/init.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/mutex.o: ../krnl/mutex.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/mutex.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/mutex.o ../krnl/mutex.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/mutex.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/event.o: ../krnl/event.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/event.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/event.o ../krnl/event.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/event.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/fubar.o: ../krnl/fubar.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/fubar.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/fubar.o ../krnl/fubar.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/fubar.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/mmregion.o: ../krnl/mmregion.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/mmregion.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/mmregion.o ../krnl/mmregion.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/mmregion.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/pcr.o: ../krnl/pcr.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/pcr.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/pcr.o ../krnl/pcr.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/pcr.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/exception.o: ../krnl/exception.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/exception.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/exception.o ../krnl/exception.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/exception.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/addrmap.o: ../krnl/addrmap.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/addrmap.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/addrmap.o ../krnl/addrmap.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/addrmap.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/syscall.o: ../krnl/syscall.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/syscall.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/syscall.o ../krnl/syscall.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/syscall.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/idle.o: ../krnl/idle.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/idle.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/idle.o ../krnl/idle.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/idle.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/xmips.o: ../krnl/xmips.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/xmips.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/xmips.o ../krnl/xmips.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/xmips.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/serial.o: ../krnl/serial.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/serial.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/serial.o ../krnl/serial.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/serial.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/iomgr.o: ../krnl/iomgr.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/iomgr.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/iomgr.o ../krnl/iomgr.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/iomgr.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/debug.o: ../krnl/debug.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/debug.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/debug.o ../krnl/debug.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/debug.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/drv_14seg.o: ../krnl/drv_14seg.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/drv_14seg.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/drv_14seg.o ../krnl/drv_14seg.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/drv_14seg.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/numlib.o: ../krnl/numlib.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/numlib.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/numlib.o ../krnl/numlib.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/numlib.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/andytest.o: ../krnl/andytest.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/andytest.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/andytest.o ../krnl/andytest.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/andytest.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/drv_sdcard.o: ../krnl/drv_sdcard.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/drv_sdcard.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/drv_sdcard.o ../krnl/drv_sdcard.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/drv_sdcard.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/wait.o: ../krnl/wait.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/wait.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/wait.o ../krnl/wait.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/wait.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/fs_jankyfs.o: ../krnl/fs_jankyfs.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/fs_jankyfs.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/fs_jankyfs.o ../krnl/fs_jankyfs.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/fs_jankyfs.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/file.o: ../krnl/file.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/file.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/file.o ../krnl/file.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/file.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/utils.o: ../krnl/utils.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/utils.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -D__DEBUG  -D__MPLAB_DEBUGGER_ICD3=1 -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/utils.o ../krnl/utils.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/utils.o.d",-I"../krnl" -gdwarf-2
else
${OBJECTDIR}/_ext/760856492/spinlock.o: ../krnl/spinlock.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/spinlock.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/spinlock.o ../krnl/spinlock.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/spinlock.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/interrupt.o: ../krnl/interrupt.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/interrupt.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/interrupt.o ../krnl/interrupt.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/interrupt.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/ctxswitch.o: ../krnl/ctxswitch.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/ctxswitch.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/ctxswitch.o ../krnl/ctxswitch.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/ctxswitch.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/simplemm.o: ../krnl/simplemm.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/simplemm.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/simplemm.o ../krnl/simplemm.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/simplemm.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/main.o: ../krnl/main.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/main.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/main.o ../krnl/main.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/main.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/init.o: ../krnl/init.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/init.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/init.o ../krnl/init.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/init.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/mutex.o: ../krnl/mutex.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/mutex.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/mutex.o ../krnl/mutex.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/mutex.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/event.o: ../krnl/event.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/event.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/event.o ../krnl/event.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/event.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/fubar.o: ../krnl/fubar.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/fubar.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/fubar.o ../krnl/fubar.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/fubar.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/mmregion.o: ../krnl/mmregion.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/mmregion.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/mmregion.o ../krnl/mmregion.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/mmregion.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/pcr.o: ../krnl/pcr.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/pcr.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/pcr.o ../krnl/pcr.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/pcr.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/exception.o: ../krnl/exception.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/exception.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/exception.o ../krnl/exception.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/exception.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/addrmap.o: ../krnl/addrmap.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/addrmap.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/addrmap.o ../krnl/addrmap.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/addrmap.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/syscall.o: ../krnl/syscall.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/syscall.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/syscall.o ../krnl/syscall.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/syscall.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/idle.o: ../krnl/idle.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/idle.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/idle.o ../krnl/idle.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/idle.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/xmips.o: ../krnl/xmips.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/xmips.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/xmips.o ../krnl/xmips.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/xmips.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/serial.o: ../krnl/serial.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/serial.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/serial.o ../krnl/serial.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/serial.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/iomgr.o: ../krnl/iomgr.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/iomgr.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/iomgr.o ../krnl/iomgr.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/iomgr.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/debug.o: ../krnl/debug.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/debug.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/debug.o ../krnl/debug.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/debug.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/drv_14seg.o: ../krnl/drv_14seg.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/drv_14seg.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/drv_14seg.o ../krnl/drv_14seg.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/drv_14seg.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/numlib.o: ../krnl/numlib.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/numlib.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/numlib.o ../krnl/numlib.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/numlib.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/andytest.o: ../krnl/andytest.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/andytest.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/andytest.o ../krnl/andytest.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/andytest.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/drv_sdcard.o: ../krnl/drv_sdcard.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/drv_sdcard.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/drv_sdcard.o ../krnl/drv_sdcard.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/drv_sdcard.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/wait.o: ../krnl/wait.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/wait.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/wait.o ../krnl/wait.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/wait.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/fs_jankyfs.o: ../krnl/fs_jankyfs.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/fs_jankyfs.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/fs_jankyfs.o ../krnl/fs_jankyfs.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/fs_jankyfs.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/file.o: ../krnl/file.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/file.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/file.o ../krnl/file.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/file.o.d",-I"../krnl" -gdwarf-2
${OBJECTDIR}/_ext/760856492/utils.o: ../krnl/utils.s  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/utils.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC} $(MP_EXTRA_AS_PRE)  -c -mprocessor=$(MP_PROCESSOR_OPTION)  -o ${OBJECTDIR}/_ext/760856492/utils.o ../krnl/utils.s  -Wa,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_AS_POST),--gdwarf-2,-MD="${OBJECTDIR}/_ext/760856492/utils.o.d",-I"../krnl" -gdwarf-2
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1041809461/stdlib.o: ../../../hermes/stdlib.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/stdlib.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/stdlib.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/stdlib.o.d" -o ${OBJECTDIR}/_ext/1041809461/stdlib.o ../../../hermes/stdlib.c   
	
${OBJECTDIR}/_ext/1041809461/shell_init.o: ../../../hermes/shell_init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/shell_init.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/shell_init.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/shell_init.o.d" -o ${OBJECTDIR}/_ext/1041809461/shell_init.o ../../../hermes/shell_init.c   
	
${OBJECTDIR}/_ext/1041809461/interpreter.o: ../../../hermes/interpreter.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/interpreter.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/interpreter.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/interpreter.o.d" -o ${OBJECTDIR}/_ext/1041809461/interpreter.o ../../../hermes/interpreter.c   
	
${OBJECTDIR}/_ext/1041809461/blink.o: ../../../hermes/blink.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/blink.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/blink.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/blink.o.d" -o ${OBJECTDIR}/_ext/1041809461/blink.o ../../../hermes/blink.c   
	
${OBJECTDIR}/_ext/1041809461/trampoline.o: ../../../hermes/trampoline.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/trampoline.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/trampoline.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/trampoline.o.d" -o ${OBJECTDIR}/_ext/1041809461/trampoline.o ../../../hermes/trampoline.c   
	
${OBJECTDIR}/_ext/1041809461/say.o: ../../../hermes/say.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/say.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/say.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/say.o.d" -o ${OBJECTDIR}/_ext/1041809461/say.o ../../../hermes/say.c   
	
${OBJECTDIR}/_ext/1041809461/ls.o: ../../../hermes/ls.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/ls.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/ls.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/ls.o.d" -o ${OBJECTDIR}/_ext/1041809461/ls.o ../../../hermes/ls.c   
	
${OBJECTDIR}/_ext/1041809461/cat.o: ../../../hermes/cat.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/cat.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/cat.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/cat.o.d" -o ${OBJECTDIR}/_ext/1041809461/cat.o ../../../hermes/cat.c   
	
${OBJECTDIR}/_ext/760856492/config.o: ../krnl/config.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${RM} ${OBJECTDIR}/_ext/760856492/config.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/config.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD3=1 -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/760856492/config.o.d" -o ${OBJECTDIR}/_ext/760856492/config.o ../krnl/config.c   
	
else
${OBJECTDIR}/_ext/1041809461/stdlib.o: ../../../hermes/stdlib.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/stdlib.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/stdlib.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/stdlib.o.d" -o ${OBJECTDIR}/_ext/1041809461/stdlib.o ../../../hermes/stdlib.c   
	
${OBJECTDIR}/_ext/1041809461/shell_init.o: ../../../hermes/shell_init.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/shell_init.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/shell_init.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/shell_init.o.d" -o ${OBJECTDIR}/_ext/1041809461/shell_init.o ../../../hermes/shell_init.c   
	
${OBJECTDIR}/_ext/1041809461/interpreter.o: ../../../hermes/interpreter.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/interpreter.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/interpreter.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/interpreter.o.d" -o ${OBJECTDIR}/_ext/1041809461/interpreter.o ../../../hermes/interpreter.c   
	
${OBJECTDIR}/_ext/1041809461/blink.o: ../../../hermes/blink.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/blink.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/blink.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/blink.o.d" -o ${OBJECTDIR}/_ext/1041809461/blink.o ../../../hermes/blink.c   
	
${OBJECTDIR}/_ext/1041809461/trampoline.o: ../../../hermes/trampoline.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/trampoline.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/trampoline.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/trampoline.o.d" -o ${OBJECTDIR}/_ext/1041809461/trampoline.o ../../../hermes/trampoline.c   
	
${OBJECTDIR}/_ext/1041809461/say.o: ../../../hermes/say.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/say.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/say.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/say.o.d" -o ${OBJECTDIR}/_ext/1041809461/say.o ../../../hermes/say.c   
	
${OBJECTDIR}/_ext/1041809461/ls.o: ../../../hermes/ls.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/ls.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/ls.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/ls.o.d" -o ${OBJECTDIR}/_ext/1041809461/ls.o ../../../hermes/ls.c   
	
${OBJECTDIR}/_ext/1041809461/cat.o: ../../../hermes/cat.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1041809461 
	@${RM} ${OBJECTDIR}/_ext/1041809461/cat.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/1041809461/cat.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/1041809461/cat.o.d" -o ${OBJECTDIR}/_ext/1041809461/cat.o ../../../hermes/cat.c   
	
${OBJECTDIR}/_ext/760856492/config.o: ../krnl/config.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/760856492 
	@${RM} ${OBJECTDIR}/_ext/760856492/config.o.d 
	@${FIXDEPS} "${OBJECTDIR}/_ext/760856492/config.o.d" $(SILENT) -rsi ${MP_CC_DIR}../  -c ${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION) -I"../../../hermes" -MMD -MF "${OBJECTDIR}/_ext/760856492/config.o.d" -o ${OBJECTDIR}/_ext/760856492/config.o ../krnl/config.c   
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compileCPP
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -mdebugger -D__MPLAB_DEBUGGER_ICD3=1 -mprocessor=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD3=1,-L"../../../../../../Program Files/Microchip/MPLAB C32 Suite/lib",-L"../../../../../../Program Files/Microchip/MPLAB C32 Suite/pic32mx/lib",-Map="${DISTDIR}/krnl.X.${IMAGE_TYPE}.map"
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -mprocessor=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),-L"../../../../../../Program Files/Microchip/MPLAB C32 Suite/lib",-L"../../../../../../Program Files/Microchip/MPLAB C32 Suite/pic32mx/lib",-Map="${DISTDIR}/krnl.X.${IMAGE_TYPE}.map"
	${MP_CC_DIR}\\xc32-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/krnl.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} 
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
