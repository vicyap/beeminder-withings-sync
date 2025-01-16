defmodule BeeminderWithingsSyncWeb.GoalLiveTest do
  use BeeminderWithingsSyncWeb.ConnCase

  import Phoenix.LiveViewTest
  import BeeminderWithingsSync.AccountsFixtures
  import BeeminderWithingsSync.GoalsFixtures

  @create_attrs %{slug: "some slug"}
  @update_attrs %{slug: "some updated slug"}
  @invalid_attrs %{slug: nil}

  defp create_goal(_) do
    user = user_fixture()
    goal = goal_fixture(%{user_id: user.id})
    %{goal: goal, user: user}
  end

  describe "Index" do
    setup [:create_goal]

    test "lists all goals", %{conn: conn, goal: goal, user: user} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/app/goals")

      assert html =~ "Listing Goals"
      assert html =~ goal.slug
    end

    test "saves new goal", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/app/goals")

      assert index_live |> element("a", "New Goal") |> render_click() =~
               "New Goal"

      assert_patch(index_live, ~p"/app/goals/new")

      assert index_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#goal-form", goal: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/app/goals")

      html = render(index_live)
      assert html =~ "Goal created successfully"
      assert html =~ "some slug"
    end

    test "updates goal in listing", %{conn: conn, goal: goal, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/app/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Edit") |> render_click() =~
               "Edit Goal"

      assert_patch(index_live, ~p"/app/goals/#{goal}/edit")

      assert index_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#goal-form", goal: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/app/goals")

      html = render(index_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "some updated slug"
    end

    test "deletes goal in listing", %{conn: conn, goal: goal, user: user} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/app/goals")

      assert index_live |> element("#goals-#{goal.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#goals-#{goal.id}")
    end
  end

  describe "Show" do
    setup [:create_goal]

    test "displays goal", %{conn: conn, goal: goal, user: user} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/app/goals/#{goal}")

      assert html =~ "Show Goal"
      assert html =~ goal.slug
    end

    test "updates goal within modal", %{conn: conn, goal: goal, user: user} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/app/goals/#{goal}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Goal"

      assert_patch(show_live, ~p"/app/goals/#{goal}/show/edit")

      assert show_live
             |> form("#goal-form", goal: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#goal-form", goal: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/app/goals/#{goal}")

      html = render(show_live)
      assert html =~ "Goal updated successfully"
      assert html =~ "some updated slug"
    end
  end
end
