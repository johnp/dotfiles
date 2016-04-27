set debug-file-directory /home/johnp/.symbols

# .gdbinit file for debugging Mozilla

# DumpJSStack
# DumpJSValue

# Don't stop for the SIG32/33/etc crap that Flash produces
handle SIG32 noprint nostop pass
handle SIG33 noprint nostop pass
handle SIGPIPE noprint nostop pass

# Deal with nsICrap
set print object on

# run when using the auto-solib-add trick
def prun
        tbreak main
        run
        set auto-solib-add 0
        cont
end

# Define a "pu" command to display PRUnichar * strings (100 chars max)
# Also allows an optional argument for how many chars to print as long as
# it's less than 100.
def pu
  set $uni = $arg0
  if $argc == 2
    set $limit = $arg1
    if $limit > 100
      set $limit = 100
    end
  else
    set $limit = 100
  end
  # scratch array with space for 100 chars plus null terminator.  Make
  # sure to not use ' ' as the char so this copy/pastes well.
  set $scratch = "____________________________________________________________________________________________________"
  set $i = 0
  set $scratch_idx = 0
  while (*$uni && $i++ < $limit)
    if (*$uni < 0x80)
      set $scratch[$scratch_idx++] = *(char*)$uni++
    else
      if ($scratch_idx > 0)
	set $scratch[$scratch_idx] = '\0'
	print $scratch
	set $scratch_idx = 0
      end
      print /x *(short*)$uni++
    end
  end
  if ($scratch_idx > 0)
    set $scratch[$scratch_idx] = '\0'
    print $scratch
  end
end

# Define a "ps" command to display subclasses of nsAC?String.  Note that
# this assumes strings as of Gecko 1.9 (well, and probably a few
# releases before that as well); going back far enough will get you
# to string classes that this function doesn't work for.
def ps
  set $str = $arg0
  if (sizeof(*$str.mData) == 1 && ($str.mFlags & 1) != 0)
    print $str.mData
  else
    pu $str.mData $str.mLength
  end
end

def whats
   x/wa *(void**) $arg0
end

def jsstack
   call DumpJSStack()
end

def frametree
  set $r = ($arg0)->PresContext()->GetPresShell()->GetRootFrame()
  if ($r)
    call $r->List((FILE*)__stderrp, 2)
  end
end

def frametreelimited
  call $arg0->List((FILE*)__stderrp, 2)
end

def frametree192
  set $r = ($arg0)->PresContext()->GetPresShell()->GetRootFrame()
  if ($r)
    call ((class nsIFrameDebug*)(class ViewportFrame*)$r)->List((FILE*)__stderrp, 2)
  end
end

def frametree19
  set $r = ($arg0)->GetPresContext()->GetPresShell()->GetRootFrame()
  if ($r)
    call ((class nsIFrameDebug*)(class ViewportFrame*)$r)->List($r->GetPresContext(), (FILE*)__stderrp, 2)
  end
end

def frametree192-other
  set $r = ($arg0)->GetPresShell()->GetRootFrame()
  if ($r)
    call ((class nsIFrameDebug*)(class ViewportFrame*)$r)->List((FILE*)__stderrp, 2)
  end
end

def satom
  p *((class nsStaticAtomWrapper*)$arg0)->mStaticAtom
end

def atom
  p (char*)((class AtomImpl*)$arg0)->mString
end

def jsclass
  # Look in the class slot
  p *(JSClass*)(((JSObject*)$arg0)->classword & ~3)
end

def jsscript
  # Assume this is a Function object and look in the private slot
  set $fun = (JSFunction*)($arg0->slots[3] & ~1)
  # Is it interpreted?
  if ($fun->flags & 0x8000)
    p *$fun->u.i.script
  else
    p "native"
  end
end

