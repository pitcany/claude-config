#!/bin/bash
# List all available Claude Code skills

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    USER CUSTOM SKILLS                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ -d ~/.claude/skills ]; then
    # Count both directories with SKILL.md and standalone .md files
    skill_count=$(find ~/.claude/skills -maxdepth 1 -type d ! -name skills ! -name ".*" | wc -l | tr -d ' ')
    md_count=$(ls -1 ~/.claude/skills/*.md 2>/dev/null | grep -v ".bak" | wc -l | tr -d ' ')
    total_skills=$((skill_count + md_count))

    if [ "$total_skills" -gt 0 ]; then
        echo "🔹 CUSTOM USER SKILLS ($total_skills skills):"
        # List directory-based skills
        find ~/.claude/skills -maxdepth 1 -type d ! -name skills ! -name ".*" -exec basename {} \; | sed 's/^/  • /'
        # List standalone .md skills (excluding backups)
        ls -1 ~/.claude/skills/*.md 2>/dev/null | grep -v ".bak" | xargs -n 1 basename | sed 's/\.md$//' | sed 's/^/  • /'
        echo ""
    fi
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║          CACHED PLUGINS (superpowers-marketplace)          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "🔹 SUPERPOWERS (21 skills):"
ls ~/.claude/plugins/cache/superpowers/skills/ 2>/dev/null | sed 's/^/  • /'
echo ""

echo "🔹 ELEMENTS-OF-STYLE (1 skill):"
ls ~/.claude/plugins/cache/elements-of-style/skills/ 2>/dev/null | sed 's/^/  • /'
echo ""

echo "🔹 EPISODIC-MEMORY (1 skill):"
ls ~/.claude/plugins/cache/episodic-memory/skills/ 2>/dev/null | sed 's/^/  • /'
echo ""

echo "🔹 SUPERPOWERS-LAB (1 skill):"
ls ~/.claude/plugins/cache/superpowers-lab/skills/ 2>/dev/null | sed 's/^/  • /'
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║        WORKFLOW PLUGINS (claude-code-workflows)            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# List all workflow plugins that have skills
for plugin_dir in ~/.claude/plugins/marketplaces/claude-code-workflows/plugins/*/skills; do
    if [ -d "$plugin_dir" ]; then
        plugin_name=$(basename $(dirname "$plugin_dir"))
        skill_count=$(ls -d "$plugin_dir"/*/ 2>/dev/null | wc -l | tr -d ' ')
        if [ "$skill_count" -gt 0 ]; then
            echo "🔹 $plugin_name ($skill_count skills):"
            ls "$plugin_dir" | sed 's/^/  • /'
            echo ""
        fi
    fi
done

echo "╔════════════════════════════════════════════════════════════╗"
echo "║             AGENTS (claude-code-plugins)                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

for plugin_dir in ~/.claude/plugins/marketplaces/claude-code-plugins/plugins/*/agents; do
    if [ -d "$plugin_dir" ]; then
        plugin_name=$(basename $(dirname "$plugin_dir"))
        agent_count=$(ls "$plugin_dir"/*.md 2>/dev/null | wc -l | tr -d ' ')
        if [ "$agent_count" -gt 0 ]; then
            echo "🔹 $plugin_name ($agent_count agents):"
            ls "$plugin_dir" | sed 's/\.md$//' | sed 's/^/  • /'
            echo ""
        fi
    fi
done

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║               PROJECT-LEVEL SKILLS (optional)              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ -d .claude/skills ]; then
    skill_count=$(ls -1 .claude/skills/*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$skill_count" -gt 0 ]; then
        echo "🔹 PROJECT SKILLS in $(pwd) ($skill_count skills):"
        ls -1 .claude/skills/ | sed 's/\.md$//' | sed 's/^/  • /'
        echo ""
    else
        echo "  (No project-level skills in current directory)"
        echo ""
    fi
else
    echo "  (No .claude/skills directory in current project)"
    echo ""
fi

echo "💡 To use a skill: Use the Skill tool with the skill name"
echo "💡 Example in conversation: 'I want to use the brainstorming skill'"
echo "💡 User skills location: ~/.claude/skills/"
echo "💡 Project skills location: ./.claude/skills/ (in any project)"
