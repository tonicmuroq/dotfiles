"""Kitten to equalize window sizes along a given axis in the splits layout."""


def main(args):
    pass


from kittens.tui.handler import result_handler
from kitty.fast_data_types import add_timer, remove_timer


def count_leaves(node, axis):
    """Count units this node occupies on the given axis."""
    if not hasattr(node, 'one'):
        return 1
    if node.horizontal == axis:
        # Same axis: children contribute separately
        return count_leaves(node.one, axis) + count_leaves(node.two, axis)
    else:
        # Different axis: whole subtree is one unit on this axis
        return 1


def equalize(node, axis):
    """Equalize all splits along the given axis."""
    if not hasattr(node, 'one'):
        return
    if node.horizontal == axis:
        left = count_leaves(node.one, axis)
        right = count_leaves(node.two, axis)
        node.bias = left / (left + right)
    equalize(node.one, axis)
    equalize(node.two, axis)


def equalize_tab(boss, tab, axis=None):
    if tab is None or tab not in boss.all_tabs:
        return
    root = getattr(tab.current_layout, 'pairs_root', None)
    if root is None:
        return
    for a in (True, False) if axis is None else (axis,):
        equalize(root, a)
    tab.relayout()


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    # 'h' for hsplit, 'v' for vsplit, default: both axes
    axis = {'v': True, 'h': False}.get(args[1]) if len(args) > 1 else None
    equalize_tab(boss, boss.active_tab, axis)


def on_close(boss, window, data):
    tabref = window.tabref

    # on_close fires while the window is still in the layout, until kitty reaps its process
    def equalize_once_removed(timer_id):
        tab = tabref()
        if tab is not None and window in tab.windows:
            return
        remove_timer(timer_id)
        equalize_tab(boss, tab)

    add_timer(equalize_once_removed, 0.05, True)
